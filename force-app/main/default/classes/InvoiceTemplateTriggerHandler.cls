public class InvoiceTemplateTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public InvoiceTemplateTriggerHandler (boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnAfterInsert(List<Invoice_Template__c> l_new) {
        Set<Id> s_ids = new Set<Id>(); 
        Set<Id> s_accids = new Set<Id>(); 
        for(Invoice_Template__c item : l_new) {
            if (item.Contract__c != null) {
                s_ids.add(item.Contract__c);
            }
            if (item.Account__c != null) {
                s_accids.add(item.Account__c);
            }
        }
        updateContract(s_ids);
        //updateAccounts(s_accids);
    }

   
    
    public void OnAfterUpdate(List<Invoice_Template__c> l_old,List<Invoice_Template__c> l_new, Map<Id, Invoice_Template__c> m_new, Map<Id, Invoice_Template__c> m_old ){
        Set<Id> s_ids = new Set<Id>(); 
        Set<Id> s_accids = new Set<Id>();
        String minimumFeePeriod;
        for(Invoice_Template__c item : l_new) {
            Invoice_Template__c oldrec = m_old.get(item.Id);
            if (item.Contract__c != null) {
                s_ids.add(item.Contract__c);
            }
            if (item.Account__c != null) {
                s_accids.add(item.Account__c);
            }
            if(item.File_Type__c == 'Minimum Fee'){
                minimumFeePeriod = item.Invoicing_Period__c;
            }
        }
        updateContract(s_ids);
        updateContractMinimumFeePeriod(s_ids, minimumFeePeriod);
        //updateAccounts(s_accids);
    }
    
    
    public void OnAfterDelete(List<Invoice_Template__c> l_old){
        Set<Id> s_ids = new Set<Id>();
        Set<Id> s_accids = new Set<Id>();
        for(Invoice_Template__c item : l_old) {
            if (item.Contract__c != null) {
                s_ids.add(item.Contract__c);
            }
            if (item.Account__c != null) {
                s_accids.add(item.Account__c);
            }
        }
        updateContract(s_ids);
        //updateAccounts(s_accids);
    }

    public static void updateAccounts(Set<Id> s_ids) {
        List<Account> l_accounts = new List<Account>();
        for(Id sId : s_ids) {
            l_accounts.add(new Account(Id = sId));
        }
        update l_accounts;
    }
    public static void updateContract(Set<Id> s_ids){
        if(s_ids.size() > 0){
            List<Contract> l_contracts = [SELECT Id, Highest_Payment_Terms_Code__c,AccountId, (SELECT Id, Payment_Terms_Code__c, Automated_Billing__c, End_Date__c, Is_Payment_Terms_Higher__c FROM Invoice_Templates__r) FROM  Contract WHERE Id IN:s_ids ];
            Map<Id, Account> m_accounts = new Map<Id, Account>();
            for(Contract c : l_contracts) {
                Boolean isUpdateNeeded = false;
                Decimal highestValue = null;
                Decimal totalPaymentTerms = 0;
                Boolean isPaymentTermsHigher = false;
                Boolean isAutomatedBilling = false;
                for(Invoice_Template__c it : c.Invoice_Templates__r) {
                    if (it.End_Date__c == null) {
                        isUpdateNeeded = true;
                        Decimal value = 0;
                        try{
                            value = decimal.valueOf(it.Payment_Terms_Code__c);
                        }
                        catch (Exception e){}
                        if (highestValue == null || highestValue < value) {
                            highestValue = value;
                        }
                        if(value != null){
                            totalPaymentTerms += value;
                        }
                        if(it.Is_Payment_Terms_Higher__c){
                            isPaymentTermsHigher = it.Is_Payment_Terms_Higher__c;
                        }
                    }
                    if (it.Automated_Billing__c) {
                        isAutomatedBilling = it.Automated_Billing__c;
                    }
                }
                if (isUpdateNeeded) {
                    c.Highest_Payment_Terms_Code__c = highestValue;
                    c.Total_Payment_Terms__c = totalPaymentTerms;
                    c.Is_Approval_Needed_For_Payment_terms__c = isPaymentTermsHigher;
                }
                if(isAutomatedBilling) {
                    m_accounts.put(c.AccountId, new Account(Id = c.AccountId, Automated_Billing__c = isAutomatedBilling));
                }
            }
            update l_contracts;
            if (m_accounts.size() > 0) {
                update m_accounts.values();
            }    
        }
    }
    
    public static void updateContractMinimumFeePeriod(Set<Id> s_contractIds, String minimumFeePeriod){
        if(s_contractIds.size() > 0 && minimumFeePeriod != null){
            String recordType;
            List<Contract> l_contracts = [SELECT Id, Minimum_Fee_Period__c, RecordType.DeveloperName FROM Contract WHERE Id IN :s_contractIds];
            for(Contract c : l_contracts){
                recordType = c.RecordType.DeveloperName;
                c.Minimum_Fee_Period__c = minimumFeePeriod;
            }
            if(recordType.equals('BMSA')){
                update l_contracts;
            }
        }
    }
}