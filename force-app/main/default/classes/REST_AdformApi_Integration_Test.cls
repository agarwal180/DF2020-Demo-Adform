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
private class REST_AdformApi_Integration_Test{
    // Unit test setup. Create all required data for testing
    @testSetup static void initData() {
        List<Account> l_accounts = new List<Account>();
        Account acc1 = new Account(Name ='BrandAdvert', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
        acc1.BillingCity = 'New York';
        acc1.BillingCountryCode = 'US';
        acc1.BillingStreet = 'Avenue';
        acc1.BillingStateCode = 'NY';
        acc1.BillingPostalCode = '12412';
        l_accounts.add(acc1);
        Account acc2 = new Account(Name ='BrandAdvert1', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
        acc2.BillingCity = 'New York';
        acc2.BillingCountryCode = 'US';
        acc2.BillingStreet = 'Avenue';
        acc2.BillingStateCode = 'NY';
        acc2.BillingPostalCode = '12412';
        l_accounts.add(acc2);
        Account acc3 = new Account(Name ='BrandAdvert2', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
        acc3.BillingCity = 'New York';
        acc3.BillingCountryCode = 'US';
        acc3.BillingStreet = 'Avenue';
        acc3.BillingStateCode = 'NY';
        acc3.BillingPostalCode = '12412';
        l_accounts.add(acc3);
        Account acc4 = new Account(Name ='BrandAdvert3', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
        acc4.BillingCity = 'New York';
        acc4.BillingCountryCode = 'US';
        acc4.BillingStreet = 'Avenue';
        acc4.BillingStateCode = 'NY';
        acc4.BillingPostalCode = '12412';
        l_accounts.add(acc4);
        insert l_accounts;
        List<RecordType> l_recordTypes = [SELECT Id FROM  RecordType WHERE DeveloperName  IN ('Account_ID','End_Client_ID','Inventory_ID')];
        List<Platform_ID__c> l_platforms = new List<Platform_ID__c>();
        for(RecordType item : l_recordTypes) {
          l_platforms.add(new Platform_ID__c(Account__c = acc1.Id, Account_ID__c = 1424, User_Group_ID__c = 2412, End_Client_Id__c = 2352, RecordTypeID = item.Id));
        }
        insert l_platforms;

        List<String> l_objects = new List<String>{'Account', 'Platform_ID__c'};
        for(String obj : l_objects) {
            Map<String, Schema.SObjectField> m_fields =Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap();
            API_Object__c tempObject = new API_Object__c(name = obj, Api_Object_Name__c = obj, Is_Active__c = true);
            insert tempObject;
            List<API_Field__c> l_fields = new List<API_Field__c>();
            //l_fields.add(new API_Field__c(Api_Object__c = tempObject.Id, Field_Name__c = 'Id', Is_Active__c = true, Json_Attribute__c = 'id'));
            for(Schema.SObjectField field : m_fields.values()) {
                //if (field.getDescribe().) {
                    String jsonAttribute = field.getDescribe().getName().replace('__c', '');
                    jsonAttribute = field.getDescribe().getName().replace('_', '');
                    jsonAttribute = jsonAttribute.toLowerCase();
                    l_fields.add(new API_Field__c(Api_Object__c = tempObject.Id, Field_Name__c = field.getDescribe().getName(), Is_Active__c = true, Json_Attribute__c = jsonAttribute));
                //}
            }
            insert l_fields;
        }
    }

    static testMethod void testNoObject(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/AdformAPI/Account1/getIds';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            REST_AdformApi_Integration.getData();
            System.assertEquals(RestContext.response.statusCode, 405);
        Test.stopTest();
    }   
    static testMethod void testNoMethod(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/AdformAPI/Account1/getIds322';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            REST_AdformApi_Integration.getData();
            System.assertEquals(RestContext.response.statusCode, 405);
        Test.stopTest();
    }   
    static testMethod void testNoFields(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/AdformAPI/Account1/getIds';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            REST_AdformApi_Integration.getData();
            System.assertEquals(RestContext.response.statusCode, 405);
        Test.stopTest();
    }  
    static testMethod void testgetIds(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/AdformAPI/Account/getIds';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            REST_AdformApi_Integration.getData();
            System.assertEquals(RestContext.response.statusCode, 200);
        Test.stopTest();
    } 
    static testMethod void testgetRecords(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/AdformAPI/Account/getRecords'; 
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            REST_AdformApi_Integration.getData();
            System.assertEquals(RestContext.response.statusCode, 200);
        Test.stopTest();
    } 
    static testMethod void testgetById(){
        List<String> l_ids = new List<Id>();
        for(Account item : [SELECT Id FROM Account]) {
            l_ids.add(item.Id);
        }
        String str = JSON.serialize(l_ids);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/AdformAPI/Account/getById';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(str);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            REST_AdformApi_Integration.postData();
            System.assertEquals(RestContext.response.statusCode, 200);
        Test.stopTest();
    } 
    
     
    
}