public class CaseTriggerHandler {

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public CaseTriggerHandler(boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert(Case[] newCases) {

    }

    public void OnAfterInsert(Case[] newCases) {
        List<Platform_ID__c> l_platforms = new List<Platform_ID__c>();
        Set<Id> s_caseId = new Set<Id>();
        Id caseRecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Platform_Account_Creation').getRecordTypeId();
        for(Case item : newCases){
            s_caseId.add(item.Id);
            if(item.Status != null && item.Status == 'Closed Resolved' && item.RecordTypeId == caseRecordTypeId){
                Platform_ID__c platform = new Platform_ID__c();
                platform.Account__c = item.AccountId;
                platform.Account_ID__c = item.Platform_ID__c;
                platform.Billing_Title__c = item.Billing_title__c;
                platform.CurrencyIsoCode = item.CurrencyIsoCode;
                platform.Start_Date__c = system.today();
                l_platforms.add(platform);
            }
        }
        //send email by office and recordType
        /*List<Case> l_cases = [SELECT Id, RecordTypeId, OwnerId FROM Case WHERE Id IN :s_caseId];
        List<Engagment_Request_List__c> l_engReq = [SELECT Id, Template__c, Name, Contact__c FROM Engagment_Request_List__c];
        for(Case c : l_cases){
            RecordType rt = [SELECT Id, Name FROM RecordType WHERE Id = :c.RecordTypeId LIMIT 1];
            if(rt.Name.equals('Engagement Request')){
                User owner = [SELECT Id, Office__c FROM User WHERE Id = :c.OwnerId LIMIT 1];
                for(Engagment_Request_List__c er : l_engReq ){
                    if(owner.Office__c.equals(er.Name)){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setSaveAsActivity(false);
                        mail.setTargetObjectId(er.Contact__c);
                        mail.setTemplateId(er.Template__c);
                        mail.setWhatId(c.Id);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage [] { mail });
                    }
                }
            }
        }*/
        if(l_platforms.size() > 0){
            upsert l_platforms;
        }
    }


    public void OnBeforeUpdate(Case[] oldCases, Case[] updatedCases, Map<ID, Case> CaseMap, Map<ID, Case> oldCaseMap) {
        Date todayDate = Date.today();
        Integer NumberOfDays = date.daysInMonth(todayDate.year(), todayDate.month());
        Date startDate = todayDate.toStartOfMonth();
        Date endDate = date.newInstance(todayDate.year(), todayDate.month(), NumberOfDays);
        List<Contract> contracts = new List<Contract>();
        for(Case item: updatedCases) {
            if(item.Status == 'Production done and ready to bill' && oldCaseMap.get(item.Id).Status != 'Production done and ready to bill') {
                if (item.Invoicing_Period_From__c == null && item.Invoicing_Period_To__c == null) {
                    item.Invoicing_Period_From__c = startDate;
                    item.Invoicing_Period_To__c = endDate;
                }
                if (item.Contract__c != null) {
                    contracts.add(new Contract (Id=item.Contract__c, Status = 'Contract Closed'));
                }
            }
        }
        if(contracts.size() > 0){
            update contracts;
        }
    }

    public void OnAfterUpdate(Case[] oldCases, Case[] updatedCases, Map<ID, Case> CaseMap)  {
        Set<Id> s_accountIds = new Set<Id>();
        Set<Double> s_platformIds = new Set<Double>();
        for(Case item : updatedCases) {
            if (item.AccountId != null) {
                s_accountIds.add(item.AccountId);
            }
            if (item.Platform_ID__c != null) {
                s_platformIds.add(item.Platform_ID__c);
            }
        }
        List<Platform_ID__c> l_ids = [SELECT Id, Account__c, Account_ID__c, Name FROM Platform_ID__c WHERE Account__c IN :s_accountIds AND Account_ID__c IN :s_platformIds];
        Map<Double, Id> m_accounts = new Map<Double, Id>();
        for(Platform_ID__c item : l_ids) {
            m_accounts.put(item.Account_ID__c, item.Account__c);
        }
        Id caseRecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Platform_Account_Creation').getRecordTypeId();
        List<Platform_ID__c> l_platforms = new List<Platform_ID__c>();
        for(Case item : updatedCases) {
            if(item.Status != null && item.Status == 'Closed Resolved' && item.RecordTypeId == caseRecordTypeId){
                Id accountId = m_accounts.get(item.Platform_ID__c);
                if (accountId == null || (accountId != null && accountId != item.AccountId)){
                    Platform_ID__c platform = new Platform_ID__c();
                    platform.Account__c = item.AccountId;
                    platform.Account_ID__c = item.Platform_ID__c;
                    platform.Billing_Title__c = item.Billing_title__c;
                    platform.CurrencyIsoCode = item.CurrencyIsoCode;
                    platform.Start_Date__c = system.today();
                    l_platforms.add(platform);
                }
            }
        }
        if(l_platforms.size() > 0){
            upsert l_platforms;
        }
    }



    public void OnBeforeDelete(Case[] CasesToDelete, Map<ID, Case> CaseMap) {

    }

    public void OnAfterDelete(Case[] deletedCases, Map<ID, Case> CaseMap)   {
    }



    public void OnUndelete(Case[] restoredCases) { }

    public boolean IsTriggerContext {
        get { return m_isExecuting; }
    }

    public boolean IsVisualforcePageContext {
        get { return !IsTriggerContext; }
    }

    public boolean IsWebServiceContext {
        get { return !IsTriggerContext; }
    }

    public boolean IsExecuteAnonymousContext {
        get { return !IsTriggerContext; }
    }

}