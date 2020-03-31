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
private class BT_BonusTarget_Test{
    // Unit test setup. Create all required data for testing
    @testSetup static void initData() {
        Bonus_Target__c bonusTarget = new Bonus_Target__c(Stage__c = 'Employee' , Employee_user__c = UserInfo.getUserId() , Status__c = 'Active');
        insert bonusTarget;
    }
    /* 
        test bonus target view
    */
    static testmethod void test_view() {
        Test.startTest();
            BonusTarget controller = new BonusTarget();
        Test.stopTest();
    }
    /* 
        test bonus target trigger
    */
    static testmethod void test_update() {
        Test.startTest();
            Bonus_Target__c bonusTarget = [select id,SVP_User__c,Manager_User__c  from Bonus_Target__c];
            bonusTarget.SVP_User__c = UserInfo.getUserId();
            //bonusTarget.Stage__c = 'SVP';
            update bonusTarget;
             bonusTarget.Manager_User__c = UserInfo.getUserId();
             //bonusTarget.Stage__c = 'Manager';
            update bonusTarget;
        Test.stopTest();
    }
    /* 
        test bonus target view page
    */
    static testmethod void test_action_page() {
        Test.startTest();
            Bonus_Target__c bonusTarget = [select id,SVP_User__c,Manager_User__c  from Bonus_Target__c];
            bonusTarget.SVP_User__c = UserInfo.getUserId();
            //bonusTarget.Stage__c = 'SVP';
            update bonusTarget;
             bonusTarget.Manager_User__c = UserInfo.getUserId();
             //bonusTarget.Stage__c = 'Manager';
            update bonusTarget;
        Test.stopTest();
    }
}