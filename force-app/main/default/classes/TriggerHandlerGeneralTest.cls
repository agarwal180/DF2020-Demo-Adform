@isTest
private class TriggerHandlerGeneralTest {
    
    @isTest static void testTriggerStopForParticularUser() {
        User firstUser = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];
        User secondUser = [SELECT Id FROM User WHERE Id != :firstUser.Id AND IsActive = true LIMIT 1];
        insert new Triggers_Settings__c(Name = 'MainObjectTrigger', Trigger_name__c = 'MainObjectTrigger', User_Id__c = firstUser.Id, Is_Active__c = false);

        System.runAs(firstUser) {
            System.assertEquals(false, TriggerHandlerGeneral.isTriggerRun('MainObjectTrigger'));
            System.assertEquals(true, TriggerHandlerGeneral.isTriggerRun('SideObjectTrigger'));
        }

        System.runAs(secondUser) {
            System.assertEquals(true, TriggerHandlerGeneral.isTriggerRun('MainObjectTrigger'));
            System.assertEquals(true, TriggerHandlerGeneral.isTriggerRun('SideObjectTrigger'));
        }       
    }
    
    @isTest static void testTriggerStopForAllUsers() {
        User firstUser = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];
        User secondUser = [SELECT Id FROM User WHERE Id != :firstUser.Id AND IsActive = true LIMIT 1];
        insert new Triggers_Settings__c(Name = 'MainObjectTrigger', Trigger_name__c = 'MainObjectTrigger', User_Id__c = 'All', Is_Active__c = false);

        System.runAs(firstUser) {
            System.assertEquals(false, TriggerHandlerGeneral.isTriggerRun('MainObjectTrigger'));
            System.assertEquals(true, TriggerHandlerGeneral.isTriggerRun('SideObjectTrigger'));
        }

        System.runAs(secondUser) {
            System.assertEquals(false, TriggerHandlerGeneral.isTriggerRun('MainObjectTrigger'));
            System.assertEquals(true, TriggerHandlerGeneral.isTriggerRun('SideObjectTrigger'));
        }
    }

    
}