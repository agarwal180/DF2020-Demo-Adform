/* 
  * Name    : OpportunityController 
  * Author  : Andrei Pruzan
  * Description   : Class used for lighting compoentns related to Opportunity object
  * Maintenance History: 1/06/2018
  
*/  
public with sharing class Aura_OpportunityController {
    @AuraEnabled
    public static List<RecordType> getRecordTypes(Id recId) {
        return [SELECT id, DeveloperName, Name, Description FROM RecordType WHERE SobjectType= 'Contract' AND isActive= true AND DeveloperName IN ('IO','BMSA')];
    }
    
    @AuraEnabled
    public static Opportunity getOpportunity(Id recId) {
        return [SELECT ID,Name,Account.Name,CurrencyIsoCode, Account.VAT_Number__c,Account.BillingCity, Account.BillingCountry, Account.BillingCountryCode, 
            Account.BillingPostalCode, Account.BillingState, Account.BillingStateCode, Account.BillingStreet,
            Account.Registered_Number__c,Campaign_Format__c, AccountId FROM Opportunity WHERE Id=:recId];
    }
    
    @AuraEnabled
    public static List<Contact> getRelatedContacts(Id recId) {
        return [SELECT Id,Name, Email FROM Contact WHERE AccountId IN (SELECT AccountId FROM Opportunity WHERE Id=: recId)];
    }
   
}