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
private class CVS_NewContractPriceController_Test{
    // Unit test setup. Create all required data for testing
    @testSetup static void initData() {
        Account acc = new Account(Name ='BrandAdvert', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
        acc.BillingCity = 'New York';
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'Avenue';
        acc.BillingStateCode = 'NY';
        acc.BillingPostalCode = '12412';
        insert acc;
        insert new Contract_price__c(Starting_Date__c = date.newinstance(Date.today().addyears(1).year(), 1, 1), Account__c = acc.Id);
        
        
    }
    /* 
        test that new contract price will be created with valid date
    */
    static testmethod void test_close_action() {
        Contract_price__c cp = [SELECT Id FROM Contract_Price__c LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(cp);
        Test.startTest();
        CVS_NewContractPriceController controller = new CVS_NewContractPriceController(stdController);
        controller.cprecord.Starting_Date__c = date.newinstance(Date.today().addyears(2).year(), 1, 1);
        controller.saveAction();
        System.assert([SELECT Id FROM Contract_Price__c].size() > 1);
        Test.stopTest();
    }
}