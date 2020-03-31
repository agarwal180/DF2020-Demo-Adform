@isTest(SeeAllData=false)
private class ContractPreviewTest {
	@testSetup 
    static void initData() {
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
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
		Map<String,Schema.RecordTypeInfo> recordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
		Id rtId = recordTypeInfo.get('Agency upsell').getRecordTypeId();
		Opportunity	opportunityRecord = new Opportunity();
		opportunityRecord.Start_From__c = 'January';
		opportunityRecord.Name = 'new record';
		opportunityRecord.StageName = 'Closed';
		opportunityRecord.CloseDate = Date.Today();
		opportunityRecord.RecordTypeId = rtId;
		insert opportunityRecord;
        Schema.DescribeSObjectResult cfrSchemaContract = Schema.SObjectType.Contract; 
		Map<String,Schema.RecordTypeInfo> recordTypeInfoContract = cfrSchemaContract.getRecordTypeInfosByName(); 
		Id rtIdContract = recordTypeInfoContract.get('Creative Production Order').getRecordTypeId();
        Contract contractTemp = new Contract();
        contractTemp.AccountId = acc.Id;
        contractTemp.StartDate = date.today();
        contractTemp.ContractTerm = 6;
        contractTemp.Devices__c = 'Desktop';
        contractTemp.Credit_Limit__c = 9;
        contractTemp.RecordTypeId = rtIdContract;
        contractTemp.Opportunity__c=opportunityRecord.Id;
        contractTemp.Client_with_MSA_PMSA__c=true;
        insert contractTemp;
    }
    @isTest
    static void contractTestForPreview(){
        Contract con=[SELECT Id,AccountId,StartDate FROM Contract];
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(con);
        ContractPreview conPreview=new ContractPreview(stdController);
        conPreview.SendInfoToClient();
        conPreview.SendMSAOrPMSA();
        conPreview.SendInfoTobilling();
        Test.stopTest();
    }
}