/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=false)
private class BillingReport_Scheduler_Test{
    // Unit test setup. Create all required data for testing
    @testSetup static void initData() {
        Account acc = new Account(Name ='BrandAdvert', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
        acc.BillingCity = 'New York';
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'Avenue';
        acc.BillingStateCode = 'NY';
        acc.BillingPostalCode = '12412';
        insert acc;
        Admin_Setting__c setting =  Admin_Setting__c.getOrgDefaults();
        if (setting == null) {
            setting = new Admin_Setting__c();
            setting.Billing_Emails__c = UserInfo.getUserEmail();
        }
        
    }
    /* 
        test that billing report launch succesfully 
    */
    static testmethod void test_BillingReport() {
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        Test.startTest();
         String jobId = System.schedule('Billing Report',
	                            CRON_EXP, 
	                            new BillingReport_Scheduler());
	    Set<String> schdulerJobNames = new Set<String>{'Billing Report'};
	    List<CronTrigger> jobs = [SELECT Id, CronJobDetail.Name, State, NextFireTime FROM CronTrigger where CronJobDetail.Name IN: schdulerJobNames ];
	    System.assert(jobs.size() > 0);
        Test.stopTest();
    }
}