@isTest(SeeAllData=false)
private class CreativeRequestControllerTest {
    @testSetup
    static void allData(){
        Account acc = new Account(Name ='BrandAdvert', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
        acc.BillingCity = 'New York';
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'Avenue';
        acc.BillingStateCode = 'NY';
        acc.BillingPostalCode = '12412';
        acc.NavisionId__c = 'NA111';
        acc.Reminder_Emails__c='ab.cd@gmail.com';
        acc.Reminder_Emails_CC__c='abcd.xyz@yahoo.com';
        insert acc;
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Case; 
		Map<String,Schema.RecordTypeInfo> recordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
		Id rtId = recordTypeInfo.get('TPAS/DSP ID').getRecordTypeId();
        Case c=new Case();
        c.Account=acc;
        c.Platform_Account_Name__c='test';
        c.Service_Agreement_Name__c='testAgreement';
        c.Country_Platform_Account__c='Denmark';
        c.Heavy_banner_limit__c=100;
        c.CurrencyIsoCode='EUR';
        c.RTB__c='No';
        c.Name_Surname__c='TEST';
        c.Email__c='testEmail@test.com';
        c.Status='New | Unreviewed';
        insert c;
    }
    @isTest
    static void saveNewTest(){
        Case ca=[SELECT Id,status,Email__c FROM Case];
        Test.startTest();
        update ca;
        ApexPages.StandardController stdController = new ApexPages.StandardController(ca);
        CreativeRequestController cc=new CreativeRequestController(stdController);
        cc.saveNew();
        Test.stopTest();
    }
}