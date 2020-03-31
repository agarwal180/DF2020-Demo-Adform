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
private class BillingIntegration_Test{
    // Unit test setup. Create all required data for testing
    @testSetup static void initData() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = recordTypeInfo.get('Agency upsell').getRecordTypeId();
        Schema.DescribeSObjectResult contractSchema = Schema.SObjectType.Contract; 
        Map<String,Schema.RecordTypeInfo> recordTypeInfoContract = contractSchema.getRecordTypeInfosByName(); 
        Id msaRTId = null;
        if (recordTypeInfoContract.get('MSA') != null) {
            msaRTId = recordTypeInfoContract.get('MSA').getRecordTypeId();
        }
        if (recordTypeInfoContract.get('MSA Doxis') != null) {
            msaRTId = recordTypeInfoContract.get('MSA Doxis').getRecordTypeId();
        }
        Account acc = new Account(Name ='BrandAdvert', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
        acc.BillingCity = 'New York';
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'Avenue';
        acc.BillingStateCode = 'NY';
        acc.BillingPostalCode = '12412';
        insert acc;
        List<RecordType> l_recordTypes = [SELECT Id FROM  RecordType WHERE DeveloperName  IN ('Account_ID','End_Client_ID','Inventory_ID')];
        List<Platform_ID__c> l_platforms = new List<Platform_ID__c>();
        for(RecordType item : l_recordTypes) {
          l_platforms.add(new Platform_ID__c(Account__c = acc.Id, Account_ID__c = 1424, User_Group_ID__c = 2412, End_Client_Id__c = 2352, RecordTypeID = item.Id));
        }
        insert l_platforms;
        // insert contract 
        Opportunity opportunityRecord = new Opportunity();
        opportunityRecord.Start_From__c = 'January';
        opportunityRecord.Name = 'new record';
        opportunityRecord.StageName = 'Closed';
        opportunityRecord.CloseDate = Date.Today();
        opportunityRecord.RecordTypeId = rtId;
        insert opportunityRecord;
        Contract contractTemp = new Contract();
        contractTemp.AccountId = acc.Id;
        contractTemp.StartDate = date.today();
        contractTemp.ContractTerm = 6;
        contractTemp.Devices__c = 'Desktop';
        contractTemp.Credit_Limit__c = 9;
        if (msaRTId != null) {
            contractTemp.RecordTypeId = msaRTId;
        }
        insert contractTemp;
        Invoice_Template__c invoiceTemplate = new Invoice_Template__c();
        invoiceTemplate.Account__c = acc.Id;
        invoiceTemplate.Contract__c = contractTemp.Id;
        invoiceTemplate.Payment_Terms_Code__c = '30';
        insert invoiceTemplate;
        //insert new billing resource
        Billing_Resource__c newResource = new Billing_Resource__c(Name = 'Test', Resource_Number__c ='TEST NUMBER');
        insert newResource;
        // insert contract price 
        Contract_Price__c contractPrice = new Contract_Price__c(Contract__c = contractTemp.Id, Invoice_Template__c=invoiceTemplate.Id, Price__c = 121, Billing_Resource__c= newResource.Id);
        insert contractPrice;
        List<Contact> l_contacts = new List<Contact>();
        l_contacts.add(new COntact(firstname = 'test', lastName = 'test' ,Sales_Role__c = 'Invoice Email CC'));
        insert l_contacts;
    }
    /* 
        test logic to return data for Accounts 
    */
    static testmethod void test_BillingIntegration() {
        Test.startTest();
            String idstr = BillingIntegration.getAllAccountIds();
            System.assert(idstr != null);
            String idstr2 = BillingIntegration.getAccountIdsFromDate(Date.Today().addDays(-5));
            System.assert(idstr2 != null);
            String idstr3 = BillingIntegration.getAccountIdsForPeriod(Date.Today().addDays(-5),Date.Today().addDays(-5));
            System.assert(idstr3 != null);
            String acc7 = BillingIntegration.getAllAccounts();
            System.assert(acc7 != null);
            Account acc = [SELECT ID FROM Account  WHERE Name = 'BrandAdvert'];
            String accstr2 = BillingIntegration.getAccountsbyId(new List<Id>{acc.Id});
            System.assert(accstr2 != null);
            String accstr3 = BillingIntegration.getAccountsFromDateByCreatedDate(Date.Today().addDays(-5));
            System.assert(accstr3 != null);
            String accstr4 = BillingIntegration.getAccountsForPeriodCreatedDate(Date.Today().addDays(-5),Date.Today().addDays(-5));
            System.assert(accstr4 != null);
            String accstr5 = BillingIntegration.getAccountsFromDateByLastModifiedDate(Date.Today().addDays(-5));
            System.assert(accstr5 != null);
            String accstr6 = BillingIntegration.getAccountsForPeriodLastModifiedDate(Date.Today().addDays(-5),Date.Today().addDays(-5));
            System.assert(accstr6 != null);
        Test.stopTest();
    }
    /* 
        test logic to return BIlling resources
    */
    static testmethod void test_getAllResources() {
        Test.startTest();
            String resourceSTR = BillingIntegration.getAllResources();
            System.assert(resourceSTR != null);
        Test.stopTest();
    }
}