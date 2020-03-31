public class ContractTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public ContractTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    public void OnAfterInsert(List<Contract> l_new) {
        RecordType rt = [SELECT ID FROM RecordType WHERE DeveloperName = 'BMSA'];
        List<Account> l_accounts = new List<Account>(); 
        Set<Id> s_ids = new Set<Id>();
        for(Contract item : l_new) {
            if (item.AccountId != null && s_ids.contains(item.AccountId) == false) {
                if (item.RecordTypeId == rt.Id && item.Approval_Status__c == 'Approved' && item.Status == 'Activated') {
                    l_accounts.add(new Account(Id = item.AccountId, Pre_payment__c = item.Pre_payment__c, Pre_payment_Amount__c = item.Pre_payment_Amount__c));
                }
                else { 
                    l_accounts.add(new Account(Id = item.AccountId));
                }
                s_ids.add(item.AccountId);
            }
        }
        update l_accounts;
    }

    public void OnBeforeUpdate(List<Contract> l_old, List<Contract> l_new, Map<Id, Contract> m_new, Map<Id, Contract> m_old ){
        Set<Id> s_ids = new Set<Id>();
        Set<Id> s_ownerIds = new Set<Id>();
        for(Contract c : l_new) {
            s_ownerIds.add(c.OwnerId);
        }
        Map<Id, User> m_users = new Map<Id, User>([SELECT ID, ManagerId FROM USER WHERE Id IN : s_ownerIds]);
        for(Contract c : l_new) {
            //c.recalculateFormulas();
            Contract oldRec = m_old.get(c.Id);
            system.debug('====APPROVE ===='+c.Is_Approval_Needed_For_Payment_terms__c);
            System.debug('total price ' + c.Total_Price__c + ' is needed ' + c.Is_Approval_Needed_For_Payment_terms__c);
            if ( c.Total_Price__c != null && c.Highest_Payment_Terms_Code__c  != null) {
                User tempUser = m_users.get(c.OwnerId);
                if (c.Approver__c != oldRec.Approver__c && c.Approver__c == null) {
                    c.Approval_Status__c = 'Approved';
                }
                else {
                    if ((c.Is_Approval_Needed_For_Payment_terms__c && ((c.Is_Approval_Needed_For_Payment_terms__c != oldRec.Is_Approval_Needed_For_Payment_terms__c) ||
                   (c.Approval_Status__c != 'Need approval' && c.Total_Payment_Terms__c != oldRec.Total_Payment_Terms__c)) ) ||
                        (c.Is_Approval_needed_Contract_prices__c && ((c.Is_Approval_needed_Contract_prices__c != oldRec.Is_Approval_needed_Contract_prices__c) || 
                   (c.Approval_Status__c != 'Need approval' && c.Total_Price__c != oldRec.Total_Price__c)))) {
                        c.Approval_Status__c = 'Need approval';
                    }
                    else if (c.Approval_Status__c == null && (c.Is_Approval_Needed_For_Payment_terms__c || c.Is_Approval_needed_Contract_prices__c) ) {
                        c.Approval_Status__c = 'Need approval';
                    }
                    else if (c.Is_Approval_Needed_For_Payment_terms__c == false && c.Is_Approval_needed_Contract_prices__c == false) {
                        c.Approval_Status__c = 'Approved';
                    }
                }

            }
        }
    }
   
    public void OnAfterUpdate(List<Contract> l_old, List<Contract> l_new, Map<Id, Contract> m_new, Map<Id, Contract> m_old){
        RecordType rt = [SELECT ID FROM RecordType WHERE DeveloperName = 'BMSA'];
        List<Account> l_accounts = new List<Account>();
        Set<Id> s_ids = new Set<Id>();
        for(Contract c : l_new) {
            if(c.Status == 'Activated' && c.Old_Contract__c != null){
                List<Invoice_Template__c> l_newInvoiceTemplates = new List<Invoice_Template__c>();
                List<Contract_Price__c> l_newContractPrice = new List<Contract_Price__c>();
                Contract oldContract = [SELECT Id, EndDate FROM Contract WHERE Id = :c.Old_Contract__c];
                List<Invoice_Template__c> l_templates = [SELECT ID, NAME, End_Date__c,
                        (SELECT ID, NAME,Ending_Date__c FROM Contract_Prices__r WHERE Ending_Date__c  = null  ORDER BY ProductCustom__r.Order__c)
                        FROM Invoice_Template__c WHERE Contract__c =:c.Old_Contract__c AND End_Date__c = null ORDER BY Product_Group__r.Order__c];
                for(Invoice_Template__c it : l_templates) {
                    if (c.Effective_date__c != null) {
                        it.End_Date__c = c.Effective_date__c.addDays(-1);
                    }
                    l_newInvoiceTemplates.add(it);
                }
                upsert l_newInvoiceTemplates;
                for(Invoice_Template__c it : l_templates) {
                    for(Contract_Price__c cp : it.Contract_Prices__r) {
                        if (c.Effective_date__c != null) {
                            cp.Ending_Date__c = c.Effective_date__c.addDays(-1);
                        }
                        l_newContractPrice.add(cp);
                    }
                }
                upsert l_newContractPrice;
                if (c.Effective_date__c != null) {
                    oldContract.End_Date__c = c.Effective_date__c.addDays(-1);
                }
                upsert oldContract;
            }
            if (c.AccountId != null && s_ids.contains(c.AccountId) == false) {
                if (c.AccountId != null) {
                    if (c.RecordTypeId == rt.Id && c.Approval_Status__c == 'Approved' && c.Status == 'Activated') {
                        l_accounts.add(new Account(Id = c.AccountId, Pre_payment__c = c.Pre_payment__c, Pre_payment_Amount__c = c.Pre_payment_Amount__c,
                                Effective_Date__c = c.Effective_date__c, Contract_Status__c = 'Active'));
                    }
                    else { 
                        l_accounts.add(new Account(Id = c.AccountId));
                    }
                }
                s_ids.add(c.AccountId);
            }
            System.debug(c.Approval_Status__c + ' approval status');
            if (c.Approval_Status__c == 'Need approval' && m_old.get(c.Id).Approval_Status__c != 'Need approval' && Test.isRunningTest() == false) {
                // Create an approval request for the Complaint
                Approval.ProcessSubmitRequest req =
                new Approval.ProcessSubmitRequest();
                req.setObjectId(c.id);
                // Submit the approval request for the Complaint
                Approval.ProcessResult result =
                Approval.process(req);
            }
            for(Contract old : l_old){
                if(c.Effective_date__c != old.Effective_date__c){
                    updateContractPriceStartingDate(c.Id, old.Effective_date__c);
                }
                if(c.Minimum_Fee_Period__c != old.Minimum_Fee_Period__c){
                    updateInvoiceTemplate(c.Id, 'Minimum Fee');
                }
            }
        }
        update l_accounts;
    }
    
    
    public void OnAfterDelete(List<Contract> l_old){
        List<Account> l_accounts = new List<Account>(); 
        Set<Id> s_ids = new Set<Id>();
        for(Contract item : l_old) {
            if (item.AccountId != null && s_ids.contains(item.AccountId) == false) {
                l_accounts.add(new Account(Id = item.AccountId));
                s_ids.add(item.AccountId);
            }
        }
        update l_accounts;
    }
    
    public static void updateContractPriceStartingDate(Id contractId, Date oldContractEffectiveDate){
        if(contractId != null){
            List<Contract_Price__c> l_cps = new List<Contract_Price__c>();
            List<Contract> l_contracts = [SELECT Id, Effective_date__c, (SELECT Id, Starting_Date__c FROM Contract_Prices__r) FROM Contract WHERE Id = :contractId];
            for(Contract c : l_contracts){
                for(Contract_Price__c cp : c.Contract_Prices__r){
                    if(oldContractEffectiveDate == cp.Starting_Date__c){
                        cp.Starting_Date__c = c.Effective_date__c;
                        l_cps.add(cp);
                    }
                }
            }
            update l_cps;
        }
    }
    
    public static void updateInvoiceTemplate(Id contractId, String invoiceTemplateName){
        if(contractId != null){
            List<Invoice_Template__c> l_its = new List<Invoice_Template__c>();
            List<Contract> l_contracts = [SELECT Id, Minimum_Fee_Period__c, RecordType.DeveloperName, (SELECT Id, File_Type__c FROM Invoice_Templates__r WHERE File_Type__c = :invoiceTemplateName) FROM Contract WHERE Id = :contractId];
            for(Contract c : l_contracts){
                if(c.RecordType.DeveloperName.equals('BMSA')){
                    for(Invoice_Template__c it : c.Invoice_Templates__r){
                        it.Invoicing_Period__c = c.Minimum_Fee_Period__c;
                        l_its.add(it);
                    }
                }
            }
            if(!l_its.isEmpty()){
                update l_its;
            }
        }
    }
}