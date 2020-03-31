@isTest(SeeAllData=false)
private class ContactSelectionForContractTest {
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
        Contact con1=new Contact();
        con1.LastName='TestLastname';
        con1.Email='abc.test@yahoo.com';
        con1.AccountId=acc.Id;
        insert con1;
    }
    @isTest
    static void selectInfoTest(){
        Account acc=[SELECT Id,Name FROM Account];
        Opportunity opp=[SELECT Id,Name,StageName,CloseDate FROM Opportunity];
        Map<Id,Contact> conMap=new Map<ID, Contact>([SELECT Id,Name,LastName,AccountId FROM Contact where AccountId=:acc.Id]);
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(opp);
        ContactSelectionForContract conSelection=new ContactSelectionForContract(stdController);
        conSelection.SelectInfo();
        conSelection.cancelAction();
        Test.stopTest();
    }
}