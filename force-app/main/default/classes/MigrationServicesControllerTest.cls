@isTest
private class MigrationServicesControllerTest{

    @testSetup
    static void initData(){
        Account acc = new Account(
            Name = 'AccountName',
            Type_of_GHG__c = 'Dentsu Aegis Network',
            Relationship_Type__c = 'Agency',
            Relationship_Status__c = 'Prospect',
            Company_Type__c = 'Large Enterprise',
            CurrencyIsoCode = 'EUR',
            Legal_Company_Name__c = 'AccountName',
            NavisionID__c = '11111',
            Account_Status__c = 'Active',
            Lock_status__c = 'Not Locked',
            Customer_Tier__c = 'Tier 1',
            BillingCountry = 'Germany',
            BillingStreet = 'Billing Street',
            BillingCity = 'Billing City',
            BillingPostalCode = '2222',
            ShippingCountry = 'Germany',
            ShippingStreet = 'Billing Street',
            ShippingCity = 'Billing City',
            ShippingPostalCode = '2222',
            Contract_Status__c = 'Active',
            Agreement_Type__c = 'TPSA',
            VAT_Number__c = '100000',
            Registered_Number__c = '100000000',
            Reminder_terms_code__c = '2',
            Finance_charge_terms_code__c = '3'
        );
        insert acc;
        
        Opportunity opp = new Opportunity(
            Name = 'OpportunityName',
            AccountId = acc.Id,
            Primary_Competitor__c = 'Not Yet Determined',
            StageName = 'Initial Discussion',
            CloseDate = System.today().addYears(1),
            CurrencyIsoCode = acc.CurrencyIsoCode
        );
        insert opp;
    }

    static testMethod void runPositiveTestCase(){
        Opportunity o = [SELECT Id FROM Opportunity WHERE Name = 'OpportunityName' AND StageName = 'Initial Discussion'];
        Test.startTest();
        PageReference myVfPage = Page.MigrationServices;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('oppId', o.Id);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(new Contract());
        
        MigrationServicesController msc = new MigrationServicesController(stdController);
        msc.contract.Effective_Date__c = date.newinstance(Date.today().addyears(2).year(), 1, 1);
        msc.contract.Package_Size__c = 'L';
        msc.contract.Migration_Model__c = 'Hybrid 1';
        msc.saveAction();
        Contract c = [SELECT Id, Package_Size__c, Migration_Model__c FROM Contract WHERE Id = :msc.contract.Id];
        System.assert(c.Package_Size__c == 'L');
        Test.stopTest();
    }
}