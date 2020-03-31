@isTest(SeeAllData=false)
private class ContactContractTest {
	@testSetup 
    static void allData() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
		Map<String,Schema.RecordTypeInfo> recordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
		Id rtId = recordTypeInfo.get('Agency upsell').getRecordTypeId();
        Schema.DescribeSObjectResult cfrSchemaContract = Schema.SObjectType.Contract; 
		Map<String,Schema.RecordTypeInfo> recordTypeInfoContract = cfrSchemaContract.getRecordTypeInfosByName(); 
		Id rtIdContract = recordTypeInfoContract.get('Creative Production Order').getRecordTypeId();
		Opportunity	opportunityRecord = new Opportunity();
		opportunityRecord.Start_From__c = 'January';
		opportunityRecord.Name = 'new record';
		opportunityRecord.StageName = 'Closed';
		opportunityRecord.CloseDate = Date.Today();
		opportunityRecord.RecordTypeId = rtId;
		insert opportunityRecord;
    }
    @isTest
    static void contactContractTestWithRecordTypes(){
        Opportunity opp=[SELECT Id,Start_From__c,Name,StageName,CloseDate,RecordTypeId FROM Opportunity];
        Test.startTest();
        PageReference pref = Page.RC_MSAcontract;
        pref.getParameters().put('id', opp.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController stdController = new ApexPages.StandardController(opp);
        ContactContract cc=new ContactContract(stdController);
        cc.selectAction();
        cc.cancelAction();
        Test.stopTest();
    }
}