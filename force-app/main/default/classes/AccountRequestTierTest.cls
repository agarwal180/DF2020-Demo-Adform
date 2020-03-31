@isTest
private class AccountRequestTierTest {
	@testSetup 
    static void allData() {
        Profile profile = [select Id from Profile limit 1];
        
        User user = new User();
        user.Username = 'newTestUser@newtestClassUser.com';
        user.LastName = 'TestUser';
        user.ProfileId = profile.Id;
        user.Alias = 'tst';
        user.Email = 'TestUser@email.com';
        user.CommunityNickname = 'NewTest';
        user.TimeZoneSidKey = 'GMT';
        user.LocaleSidKey = 'en_US';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.Country_Group__c='DK';
        insert user;
        Tier_Approvers__c ta= new Tier_Approvers__c();
        ta.Name='ALL';
        ta.Emails__c='mindaugas.galiauskas@adform.com';
        insert ta;
    }
    @isTest
    static void saveActionTest(){
        Account acc = new Account(Name ='BrandAdvert', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
        acc.BillingCity = 'New York';
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'Avenue';
        acc.BillingStateCode = 'NY';
        acc.BillingPostalCode = '12412';
        insert acc;
        
        Test.startTest();
        PageReference pref = Page.AccountCreditCheck;
        pref.getParameters().put('id', acc.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController stdController = new ApexPages.StandardController(acc);
        AccountRequestTier art=new AccountRequestTier(stdController);
        art.SaveAction();
        Test.stopTest();
    }
}