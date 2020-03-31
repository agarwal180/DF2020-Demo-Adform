/*
    * Name        : ImportData_Test
    * Author        : Dmitrij Marcinkevic
    * Description   : Class tests imported data from ImportData class
    * Maintenance History:
    * 12/06/2018
*/
@IsTest(SeeAllData = false)
public class ImportData_Test {
    @testSetup static void initData() {
        ImportData.initData();
    }

    static testmethod void getImportedDataCount_test (){
        List<Account> l_accounts = [SELECT Id FROM Account];
        System.assert(l_accounts.size() >= 20);
        /*List<Lead> l_leads = [SELECT Id FROM Lead];
        System.assert(l_leads.size() >= 20);
        List<Contact> l_contacts = [SELECT Id FROM Contact];
        System.assert(l_contacts.size() >= 120);
        List<Platform_ID__c> l_platformIds = [SELECT Id FROM Platform_ID__c];
        System.assert(l_platformIds.size() >= 60);
        List<Opportunity> l_opportunity = [SELECT Id FROM Opportunity];
        System.assert(l_opportunity.size() >= 40);
        List<Product_Group__c> l_productGroups = [SELECT Id FROM Product_Group__c];
        System.assert(l_productGroups.size() >= 2);
        List<Billing_Resource__c> l_billingResources = [SELECT Id FROM Billing_Resource__c];
        System.assert(l_billingResources.size() >= 1);
        List<Product__c> l_products = [SELECT Id FROM Product__c];
        System.assert(l_products.size() >= 4);
        List<Product_Price__c> l_productPrices = [SELECT Id FROM Product_Price__c];
        System.assert(l_productPrices.size() >= 12);
        List<Contract> l_contracts = [SELECT Id FROM Contract];
        System.assert(l_contracts.size() > 0);
        List<Invoice_Template__c> l_invoiceTemplate = [SELECT Id FROM Invoice_Template__c];
        System.assert(l_invoiceTemplate.size() >= 40);
        List<Contract_Price__c> l_contractPrices = [SELECT Id FROM Contract_Price__c];
        System.assert(l_contractPrices.size() >= 80);
        List<Case> l_cases = [SELECT Id FROM Case];
        System.assert(l_cases.size() >= 60);*/
    }
}