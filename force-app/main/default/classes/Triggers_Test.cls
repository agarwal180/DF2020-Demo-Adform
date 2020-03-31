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
private class Triggers_Test{
     @testSetup static void initData() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = recordTypeInfo.get('Agency upsell').getRecordTypeId();
        Account acc = new Account(Name ='BrandAdvert', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
        acc.BillingCity = 'New York';
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'Avenue';
        acc.BillingStateCode = 'NY';
        acc.BillingPostalCode = '12412';
        insert acc;
        Opportunity opportunityRecord = new Opportunity();
        opportunityRecord.AccountId = acc.Id;
        opportunityRecord.Start_From__c = 'January';
        opportunityRecord.Name = 'new record';
        opportunityRecord.StageName = 'Closed';
        opportunityRecord.CloseDate = Date.Today();
        opportunityRecord.RecordTypeId = rtId;
        insert opportunityRecord;
        Schema.DescribeSObjectResult ppSchema = Schema.SObjectType.Contract; 
        Map<String,Schema.RecordTypeInfo> recordTypes_Contract = ppSchema.getRecordTypeInfosByName();
        Contract contract1 = new Contract();
        contract1.AccountId = acc.Id;
        contract1.StartDate = date.today();
        contract1.ContractTerm = 6;
        contract1.Devices__c = 'Desktop';
        contract1.Total_Price__c=200;
        contract1.Highest_Payment_Terms_Code__c=20;
        contract1.Effective_date__c=date.today();
        //contract1.RecordTypeId = recordTypes_Contract.get('BMSA').getRecordTypeId();
        insert contract1;
    }

    static testmethod void test_ContractPriceTriggerHandler() {
        Test.startTest();
            Account acc = [SELECT Id, Navision_Base_Unit_of_Measure__c  FROM Account];
            Contract_Price__c cp = new Contract_Price__c(Unit_of_Measure_Code__c = 'IMPR', Account__c = acc.Id);
            insert cp;
            cp.Unit_of_Measure_Code__c = 'BUDGET';
            update cp;
            delete cp;
            acc = [SELECT Id, Navision_Base_Unit_of_Measure__c  FROM Account];
            System.assert(acc.Navision_Base_Unit_of_Measure__c == null);
        Test.stopTest();
    }

    static testmethod void test_PlatformriggerHandler() {
        Test.startTest();
            Account acc = [SELECT Id, Navision_Base_Unit_of_Measure__c  FROM Account];
            Platform_ID__c record =  new Platform_ID__c(Account__c = acc.Id, Account_ID__c = 1424, User_Group_ID__c = 2412, End_Client_Id__c = 2352);
            insert record;
            record.Account_ID__c = 14123;
            update record;
            delete record;
            acc = [SELECT Id, Navision_Base_Unit_of_Measure__c, LastModifiedDate  FROM Account];
            System.assert(acc.LastModifiedDate.Date() == Date.Today());
        Test.stopTest();
    }
    static testmethod void test_ContractTriggerHandler() {
        Test.startTest();
        Date oldContractEffectiveDate=date.today();
            Account acc = [SELECT Id, Navision_Base_Unit_of_Measure__c  FROM Account];
            Contract con=[SELECT Id,AccountId,StartDate,ContractTerm,Devices__c,Total_Price__c,Highest_Payment_Terms_Code__c,
                        Effective_date__c FROM Contract];
            Contract_Price__c cp = new Contract_Price__c(Unit_of_Measure_Code__c = 'BUDGET', Account__c = acc.Id,Contract__c=con.Id,Starting_Date__c=date.today());
            insert cp;
        	ContractTriggerHandler.updateContractPriceStartingDate(con.Id,oldContractEffectiveDate);
            Contract contractTemp = new Contract();
            contractTemp.AccountId = acc.Id;
            contractTemp.StartDate = date.today();
            contractTemp.ContractTerm = 6;
            contractTemp.Devices__c = 'Desktop';
            contractTemp.Total_Price__c=200;
            contractTemp.Highest_Payment_Terms_Code__c=20;
        	contractTemp.Effective_date__c=date.today();
            insert contractTemp;
            contractTemp.status='Activated';
        	contractTemp.Old_Contract__c=con.Id;
            update contractTemp;
            delete contractTemp;
            acc = [SELECT Id, Navision_Base_Unit_of_Measure__c, LastModifiedDate  FROM Account];
            System.assert(acc.LastModifiedDate.Date() == Date.Today());
        Test.stopTest();
    }
}