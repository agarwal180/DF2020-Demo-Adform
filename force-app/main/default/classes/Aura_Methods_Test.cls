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
private class Aura_Methods_Test{
    @testSetup static void SetupMethod() {
    Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
    Map<String,Schema.RecordTypeInfo> recordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        List<RecordType> recordTypes = [SELECT ID FROM RecordType WHERE developerName = 'Order_Contract'];
        Case caseItem1 = new Case(RecordTypeId = recordTypes[0].Id,Agency_ID__c = '1',Client_ID__c ='2' ,Campaign_ID__c='3',status='Signed and start production');
        insert caseItem1;
        Case caseItem2 = new Case(RecordTypeId = recordTypes[0].Id,Agency_ID__c = '1',Client_ID__c ='2' ,Campaign_ID__c='3',status='Executive Review');
        insert caseItem2;
        Case caseItem3 = new Case(RecordTypeId = recordTypes[0].Id,Agency_ID__c = '1',Client_ID__c ='2' ,Campaign_ID__c='3',status='Start Production');
        insert caseItem3;
        Account acc = new Account(Name ='BrandAdvert', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
        acc.BillingCity = 'New York';
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'Avenue';
        acc.BillingStateCode = 'NY';
        acc.BillingPostalCode = '12412';
        insert acc;
        Id rtId = recordTypeInfo.get('Agency upsell').getRecordTypeId();
        Opportunity opportunityRecord = new Opportunity();
        opportunityRecord.Start_From__c = 'January';
        opportunityRecord.Name = 'new record';
        opportunityRecord.StageName = 'Closed';
        opportunityRecord.CloseDate = Date.Today();
        opportunityRecord.RecordTypeId = rtId;
        insert opportunityRecord;
        Contact con1 = new Contact (LastName ='Singh', AccountId =acc.Id);
        con1.MailingCity = 'New York';
        con1.MailingCountryCode = 'US';
        con1.MailingStreet = 'Avenue';
        con1.MailingStateCode = 'NY';
        con1.MailingPostalCode = '12412';
        insert con1;
    }
    
    static testMethod void test_Case() {
        Test.startTest();
        List<Case> caseItem  = [SELECT ID,status,(SELECT ID FROM AttachedContentDocuments LIMIT 1) FROM Case LIMIT 5];
        system.debug('caseItem-----'+caseItem);
        for(Case c:caseItem){
            CaseController.getMessage(c.Id); 
        }
        Test.stopTest();
    }
    
    static testMethod void test_Opportunity() {
        Test.startTest();
        Opportunity opp  = [SELECT ID FROM Opportunity LIMIT 1];
        Aura_OpportunityController.getRecordTypes(opp.Id);
        Aura_OpportunityController.getOpportunity(opp.Id);
        Aura_OpportunityController.getRelatedContacts(opp.Id);
        Test.stopTest();
    }
}