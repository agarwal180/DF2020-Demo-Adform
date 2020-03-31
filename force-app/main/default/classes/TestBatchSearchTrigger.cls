@isTest
private class TestBatchSearchTrigger {
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
        acc.NavisionId__c = 'NA111';
        acc.Reminder_Emails__c='ab.cd@gmail.com';
        acc.Reminder_Emails_CC__c='abcd.xyz@yahoo.com';
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
    private static testMethod void testSearchAccount() {
       
        Batch_Search job = new Batch_Search();
        Test.startTest();
        	ID batchprocessid = Database.executeBatch(job,1);
        Test.stopTest();
    }
    private static testMethod void doxisIntegrationTest() {
        Test.startTest();
          RestRequest req = new RestRequest(); 
          RestResponse res = new RestResponse();
          req.requestURI = '/services/apexrest/DoxisIntegration'; //Request URL
          String jsonStr = '{"md_subject": "IT Carat Italia 2017 03 29","md_company": "Adform Aps","md_agreementType": "MSA","md_supplementType": "SDF","md_customer_name": "Carat Italia","md_vat_number": "IT08986330150","md_navisionId": ["NA111"],"md_emails": [""],"md_salesOffice": ["IT"],"md_registrationCountry": "IT","md_admintoolId": ["phit-it-"],"md_effectiveDate": "2017-03-29","md_endDate": "","md_statusDocument": "Active","md_withSLA": "false","md_prepayment": "false","md_fee": "false","md_minfee_effectiveDate": "","md_comments": "","md_id": "854e4178-af46-4036-a4b3-f048348833d2","md_weblink": "http://doxis.adform.zone:8080/webcube/?id=SD0dCOFIDOCUMENTS24854e4178-af46-4036-a4b3-f048348833d2182017-07-31T09:48:16.096Z012&system=Adform&action=showdocument&servername=Adform","md_state": "Exported","md_statecomment": ""}';
          req.requestBody = Blob.valueof(jsonStr);
          req.httpMethod = 'POST';
          RestContext.request = req;
          RestContext.response = res;
          String results = RESTDoxisIntegration.createNewContract();
          Test.stopTest();
    }
    private static testMethod void testCaseCleanUp() {
      Id recordTypeId = [SELECT ID FROM RecordType WHERE DeveloperName = 'Order_Contract'].Id;
      Case caseRec = new Case();
      caseRec.RecordTypeId = recordTypeId;
      caseRec.Subject = 'Test';
      insert caseRec;
       Batch_Cases_cleanup job = new Batch_Cases_cleanup();
        Test.startTest();
            ID batchprocessid = Database.executeBatch(job,1);
        Test.stopTest();
    }
    private static testMethod void testDocumentCleanUp() {

      Document document = new Document();
      document.Body = Blob.valueOf('Some Text');
      document.ContentType = 'application/pdf';
      document.DeveloperName = 'my_document';
      document.IsPublic = true;
      document.Name = '(IO Contract) Document';
      document.FolderId = [SELECT Id FROM Folder where Type = 'Document' LIMIT 1].Id;
      insert document;
       Batch_Documents_cleanup job = new Batch_Documents_cleanup();
        Test.startTest();
            ID batchprocessid = Database.executeBatch(job,1);
        Test.stopTest();
    }

}