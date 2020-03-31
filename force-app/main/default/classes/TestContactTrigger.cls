@isTest
private class TestContactTrigger {
    
    private static testMethod void testCompanyTypeValue() {
        Account accWithBrandAdvert = new Account(Name ='BrandAdvert', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
        Account accWithPublis = new Account(Name ='Publis', Relationship_Type__c ='Publisher', Company_Type__c ='Startup', Is_From_Lead__c  =true);
        insert new List<Account>{accWithBrandAdvert, accWithPublis};
            
        Contact con1 = new Contact (LastName ='Singh', AccountId =accWithBrandAdvert.Id);
        con1.MailingCity = 'New York';
		con1.MailingCountryCode = 'US';
		con1.MailingStreet = 'Avenue';
		con1.MailingStateCode = 'NY';
		con1.MailingPostalCode = '12412';
        Test.StartTest();
        insert con1;
        Contact conRecord =[Select AccountId, Company_Type_custom__c from Contact WHERE AccountId =:accWithBrandAdvert.Id];
        System.assertEquals('Advertiser', conRecord.Company_Type_custom__c);
            
        conRecord.AccountId = accWithPublis.Id; 
        update conRecord;
            
        Contact updateRecord =[Select AccountId, Company_Type_custom__c from Contact WHERE AccountId =:accWithPublis.Id];
        System.assertEquals('Publisher', updateRecord.Company_Type_custom__c);
        Account accUpdate =[Select Id, Relationship_Type__c FROM Account WHERE Id =:accWithPublis.Id]; 
        accUpdate.Relationship_Type__c ='Agency';
        update accUpdate;
            
        Contact conWithChange =[Select AccountId, Title, Company_Type_custom__c from Contact WHERE AccountId =:accUpdate.Id];
        conWithChange.Title ='testContact';
        update conWithChange;
       
        Contact conWithChangeTest =[Select AccountId, Title, Company_Type_custom__c from Contact WHERE AccountId =:accUpdate.Id];
        System.assertEquals('Agency', conWithChangeTest.Company_Type_custom__c);
        Test.stopTest();  
    }
}