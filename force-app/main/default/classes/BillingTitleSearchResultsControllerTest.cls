@isTest(SeeAllData=false)
private class BillingTitleSearchResultsControllerTest {
	@testSetup
    static void allData(){
        String searchValue='Test';
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
        Platform_ID__c pi=new Platform_ID__c();
        pi.Account__c=acc.Id;
        pi.Billing_Title__c='Test';
        insert pi;
    }
    @isTest
    static void getAllAccountsTest(){
        Test.startTest();
        BillingTitleSearchResultsController bt =new BillingTitleSearchResultsController();
        bt.searchAction();
        bt.homeRedirect();
        Test.stopTest();
    }
}