@isTest
private class BillingIntegrationSyncFixTest {
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
        insert contractTemp;
    }
	@isTest
    static void billingIntegationSyncFix(){
        List<Contract> con=[SELECT Id,AccountId,StartDate,Devices__c,Credit_Limit__c FROM Contract];
        Database.BatchableContext bc;
     	Test.startTest();
        BillingIntegrationSyncFix_Batch bis=new BillingIntegrationSyncFix_Batch();
        bis.execute(bc,con);
        BillingIntegrationSyncFix_Schedule.SchedulerMethod();
        Test.stopTest();
    }
}