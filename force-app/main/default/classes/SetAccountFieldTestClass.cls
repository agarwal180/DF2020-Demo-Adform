@isTest 
private class SetAccountFieldTestClass {
    static testMethod void validateSetAccountField() {
        
        Account ac = new Account (Name = 'TestAccount', Company_Type__c='Other', is_from_Lead__c=true, 
        CurrencyIsoCode='EUR', Contract_Status__c='Pending', Relationship_Type__c='Publisher');
        
        insert ac;
        
        Lead le = new Lead(FirstName='TestLead', LastName='TestLEad', Sales_Role__c='User', LeadSource='Other', 
            CurrencyIsoCode='EUR', Status='Qualified', Company='Company Name', Company_Type__c='1-10 employees', 
            Parent_Account__c=ac.Id);
        
        insert le;
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setDoNotCreateOpportunity(true);
        lc.setLeadId(le.id);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
    }
}