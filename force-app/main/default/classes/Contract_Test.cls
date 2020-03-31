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
private class Contract_Test{
    /*
    static testMethod void test_CaseTriggerhandler() {
        List<RecordType> recordTypes = [SELECT ID FROM RecordType WHERE developerName = 'Order_Contract'];
        Case caseItem = new Case(RecordTypeId = recordTypes[0].Id,Agency_ID__c = '1',Client_ID__c ='2' ,Campaign_ID__c='3');
        insert caseItem;
        Test.startTest();
            caseItem.Status = 'Production done and ready to bill';
            update caseItem;
            Case caseAfterUpdate = [SELECT Id, Status FROM Case WHERE id =: caseItem.Id];
            CaseTriggerHandler handler = new CaseTriggerHandler(true, 2);
            handler.OnBeforeInsert(new list<Case>{caseItem});
            handler.OnAfterInsert(new list<Case>{caseItem});
            handler.OnAfterUpdate(new list<Case>{caseItem}, new list<Case>{caseItem},new  Map<ID, Case> {caseItem.Id => caseItem});
            handler.OnBeforeDelete(new list<Case>{caseItem}, new  Map<ID, Case> {caseItem.Id => caseItem});
            handler.OnAfterDelete(new list<Case>{caseItem}, new  Map<ID, Case> {caseItem.Id => caseItem});
            handler.OnUndelete(new list<Case>{caseItem});
            Boolean IsTriggerContext = handler.IsTriggerContext;
            Boolean IsVisualforcePageContext =handler.IsVisualforcePageContext;
            Boolean IsWebServiceContext =handler.IsWebServiceContext;
            Boolean IsExecuteAnonymousContext =handler.IsExecuteAnonymousContext;
            System.assertEquals(caseItem.Status, caseAfterUpdate.Status);
        Test.stopTest();
    }
    static testMethod void test_EmailMessageTriggerhandler() {
        List<RecordType> recordTypes = [SELECT ID FROM RecordType WHERE developerName = 'Order_Contract'];
        Case caseItem = new Case(RecordTypeId = recordTypes[0].Id,Agency_ID__c = '1',Client_ID__c ='2' ,Campaign_ID__c='3');
        insert caseItem;
        EmailMessage testEmailMessage1 = new EmailMessage(Incoming = false, ParentId = caseItem.Id,Subject = 'Test reserveringsnummer',TextBody = 'TextBody', Status = '0',
        FromAddress = 'test@test.com',FromName = 'Test',ToAddress  = 'test@test.com',CcAddress = 'test@test.com',BccAddress = 'test@test.com', MessageDate = datetime.now());
        Test.startTest();
            insert testEmailMessage1;
            Case caseAfterUpdate = [SELECT Id, SuppliedEmail FROM Case WHERE id =: caseItem.Id];
            EmailMessageTriggerHandler handler = new EmailMessageTriggerHandler(true, 2);
            Boolean IsTriggerContext = handler.IsTriggerContext;
            Boolean IsVisualforcePageContext =handler.IsVisualforcePageContext;
            Boolean IsWebServiceContext =handler.IsWebServiceContext;
            Boolean IsExecuteAnonymousContext =handler.IsExecuteAnonymousContext;
            System.assertEquals(caseAfterUpdate.SuppliedEmail, testEmailMessage1.ToAddress);
        Test.stopTest();
    }
    
    static testMethod void test_DeleteDocuments() {
        Document document1 = new Document();
                document1.AuthorId = UserInfo.getUserId();
                document1.FolderId = UserInfo.getUserId(); // put it in running user's folder
                document1.IsPublic = true;
                document1.Name = 'new (IO Contract) new.pdf';
                document1.ContentType = 'application/pdf';
        insert document1;
        Batch_Documents_cleanup job = new Batch_Documents_cleanup();
        Test.startTest();
            ID batchprocessid = Database.executeBatch(job,1);
        Test.stopTest();
    }
    
    static testMethod void test_DeleteOldCases() {
        List<RecordType> recordTypes = [SELECT ID FROM RecordType WHERE developerName = 'Order_Contract'];
        Case caseItem = new Case(RecordTypeId = recordTypes[0].Id,Agency_ID__c = '1',Client_ID__c ='2' ,Campaign_ID__c='3');
        insert caseItem;
        Batch_Cases_cleanup job = new Batch_Cases_cleanup();
        Test.startTest();
            ID batchprocessid = Database.executeBatch(job,1);
        Test.stopTest();
    }
    static testMethod void test_ContractPDFPreview() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = recordTypeInfo.get('Agency upsell').getRecordTypeId();
        Account accWithBrandAdvert = new Account(Name ='BrandAdvert', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
        Account accWithPublis = new Account(Name ='Publis', Relationship_Type__c ='Publisher', Company_Type__c ='Startup', Is_From_Lead__c  =true);
        insert new List<Account>{accWithBrandAdvert, accWithPublis};
        Opportunity opportunityRecord = new Opportunity();
        opportunityRecord.Start_From__c = 'January';
        opportunityRecord.Name = 'new record';
        opportunityRecord.StageName = 'Closed';
        opportunityRecord.CloseDate = Date.Today();
        opportunityRecord.RecordTypeId = rtId;
        insert opportunityRecord;
        Contract contractTemp = new Contract();
        contractTemp.AccountId = accWithBrandAdvert.Id;
        contractTemp.StartDate = date.today();
        contractTemp.ContractTerm = 6;
        contractTemp.Devices__c = 'Desktop';
        insert contractTemp;
        ApexPages.StandardController stdController = new ApexPages.StandardController(contractTemp);
        Test.startTest();
            IoContractController controller = new IoContractController(stdController);
            System.assertEquals(controller.devices.size(), 3);
        Test.stopTest();
    }
    
    static testMethod void test_ContactSelection() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = recordTypeInfo.get('Agency upsell').getRecordTypeId();
        Account accWithBrandAdvert = new Account(Name ='BrandAdvert', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
        accWithBrandAdvert.BillingCity = 'New York';
        accWithBrandAdvert.BillingCountryCode = 'US';
        accWithBrandAdvert.BillingStreet = 'Avenue';
        accWithBrandAdvert.BillingStateCode = 'NY';
        accWithBrandAdvert.BillingPostalCode = '12412';
        Account accWithPublis = new Account(Name ='Publis', Relationship_Type__c ='Publisher', Company_Type__c ='Startup', Is_From_Lead__c  =true);
        insert new List<Account>{accWithBrandAdvert, accWithPublis};
        Opportunity opportunityRecord = new Opportunity();
        opportunityRecord.Start_From__c = 'January';
        opportunityRecord.Name = 'new record';
        opportunityRecord.StageName = 'Closed';
        opportunityRecord.CloseDate = Date.Today();
        opportunityRecord.RecordTypeId = rtId;
        opportunityRecord.AccountId = accWithBrandAdvert.Id;
        insert opportunityRecord;
        Contact con1 = new Contact (LastName ='Singh', AccountId =accWithBrandAdvert.Id);
        con1.MailingCity = 'New York';
        con1.MailingCountryCode = 'US';
        con1.MailingStreet = 'Avenue';
        con1.MailingStateCode = 'NY';
        con1.MailingPostalCode = '12412';
        insert con1;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(opportunityRecord);
        Test.startTest();
            ContactSelectionForContract controller = new ContactSelectionForContract(stdController);
            
            controller.selectedContact = con1.Id;
            controller.selectedEmail = 'test@test.com';
            controller.SelectInfo();
            controller.cancelAction();
        Test.stopTest();
    }
    
    static testMethod void test_ContactPreview() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = recordTypeInfo.get('Agency upsell').getRecordTypeId();
        Account accWithBrandAdvert = new Account(Name ='BrandAdvert', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
        Account accWithPublis = new Account(Name ='Publis', Relationship_Type__c ='Publisher', Company_Type__c ='Startup', Is_From_Lead__c  =true);
        insert new List<Account>{accWithBrandAdvert, accWithPublis};
        Opportunity opportunityRecord = new Opportunity();
        opportunityRecord.Start_From__c = 'January';
        opportunityRecord.Name = 'new record';
        opportunityRecord.StageName = 'Closed';
        opportunityRecord.CloseDate = Date.Today();
        opportunityRecord.RecordTypeId = rtId;
        insert opportunityRecord;
        Contract contractTemp = new Contract();
        contractTemp.AccountId = accWithBrandAdvert.Id;
        contractTemp.StartDate = date.today();
        contractTemp.ContractTerm = 6;
        contractTemp.Devices__c = 'Desktop';
        insert contractTemp;
        ApexPages.StandardController stdController = new ApexPages.StandardController(contractTemp);
        Test.startTest();
            ContractPreview controller = new ContractPreview(stdController);
            controller.SendInfoToClient();
            controller.SendMSAOrPMSA();
            controller.SendInfoTobilling();
        Test.stopTest();
    }*/
}