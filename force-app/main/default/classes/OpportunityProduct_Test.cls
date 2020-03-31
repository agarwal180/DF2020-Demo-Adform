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
private class OpportunityProduct_Test{
	 static testMethod void test_Opportunity() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
		Map<String,Schema.RecordTypeInfo> recordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
		Id rtId = recordTypeInfo.get('Agency upsell').getRecordTypeId();
		system.debug(rtId);
        Opportunity	opportunityRecord = new Opportunity();
		opportunityRecord.Start_From__c = 'January';
		opportunityRecord.Name = 'new record';
		opportunityRecord.StageName = 'Closed';
		opportunityRecord.CloseDate = Date.Today();
		opportunityRecord.RecordTypeId = rtId;
		insert opportunityRecord;
        ApexPages.StandardController stdController = new ApexPages.StandardController(opportunityRecord);
		
		Id pricebookId = Test.getStandardPricebookId();
		Product2 product_record = new Product2(Name='Test', Description='Test Product Entry 1');
		insert product_record;
		PricebookEntry standardPrice = new PricebookEntry(
				Pricebook2Id = pricebookId, Product2Id = product_record.Id,
				UnitPrice = 10000, IsActive = true);
		insert standardPrice;
        PriceBook2 pb2=new PriceBook2();
        pb2.Name = 'test';
        pb2.IsActive = true;
        insert pb2;
		PricebookEntry pbe = [ SELECT Id,Product2Id,Pricebook2Id,UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :pricebookId AND isActive=true LIMIT 1 ];
		Opportunity_Setting__c setting = new Opportunity_Setting__c();
		setting.Field_Set_Name__c = 'Agency_upsell';
		setting.Record_Type_Name__c = 'Agency_upsell';
		setting.Record_Type_Group_Name__c = 'Agency';
        setting.Price_Book_Ids__c=pricebookId;
		setting.name = 'Agency_view';
		insert setting;
		
		Test.startTest();
		ApexPages.currentPage().getParameters().put('rowNumber','0');
        ApexPages.currentPage().getParameters().put('isProductEdit','true');
        ApexPages.currentPage().getParameters().put('clone','1');
		OpportunityController controller = new OpportunityController(stdController);
		controller.SelectedRecordType = rtId;
		controller.prepareDataAfterselection();
		controller.opportunityRecord.Start_From__c = 'January';
		controller.opportunityRecord.Name = 'new record';
		controller.opportunityRecord.StageName = 'Closed';
		controller.opportunityRecord.CloseDate = Date.Today();
		controller.addProduct();
		OpportunityLineItem newItem = new OpportunityLineItem();
		
		newItem.PricebookEntryId = pbe.Id;
		newItem.X1_Month__c = 11;
		newItem.X2_Month__c = 11;
		newItem.X3_Month__c = 11;
		newItem.X4_Month__c = 11;
		newItem.X5_Month__c = 11;
		newItem.X6_Month__c = 11;
		newItem.X7_Month__c = 11;
		newItem.X8_Month__c = 11;
		newItem.X9_Month__c = 11;
		newItem.X10_Month__c = 11;
		newItem.X11_Month__c = 11;
		newItem.X12_Month__c = 11;
		newItem.UnitPrice = 1242141;
		controller.products[0] = newItem;
		controller.calculatemonth();
		controller.calculateTotalValue();
		controller.deleteRowElement();
		controller.addProduct();
		controller.products[0] = newItem;
		controller.prepareAvailabelProducts();
		controller.saveRecords();
        OpportunityController oc= new OpportunityController(stdController);
        oc.prepareREcordTypeInfo();
		Test.stopTest();
		
	 }
	 
	 static testMethod void test_Clone() {
		Id pricebookId = Test.getStandardPricebookId();
		Product2 product_record = new Product2(Name='Test', Description='Test Product Entry 1');
		insert product_record;
		PricebookEntry standardPrice = new PricebookEntry(
				Pricebook2Id = pricebookId, Product2Id = product_record.Id,
				UnitPrice = 10000, IsActive = true);
		insert standardPrice;
		PricebookEntry pbe = [ SELECT Id,Product2Id,Pricebook2Id,UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :pricebookId AND isActive=true LIMIT 1 ];
		Opportunity_Setting__c setting = new Opportunity_Setting__c();
		setting.Field_Set_Name__c = 'Agency_upsell';
		setting.Record_Type_Name__c = 'Agency_view';
		setting.Record_Type_Group_Name__c = 'Agency';
		setting.name = 'Agency_view';
		insert setting;
		
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
       
		OpportunityLineItem newItem = new OpportunityLineItem();
		
		newItem.PricebookEntryId = pbe.Id;
		newItem.OpportunityId = opportunityRecord.Id;
		newItem.X1_Month__c = 11;
		newItem.X2_Month__c = 11;
		newItem.X3_Month__c = 11;
		newItem.X4_Month__c = 11;
		newItem.X5_Month__c = 11;
		newItem.X6_Month__c = 11;
		newItem.X7_Month__c = 11;
		newItem.X8_Month__c = 11;
		newItem.X9_Month__c = 11;
		newItem.X10_Month__c = 11;
		newItem.X11_Month__c = 11;
		newItem.X12_Month__c = 11;
		newItem.UnitPrice = 1242141;
		insert newItem;
		List<OpportunityLineItem> oppLineItem= new List<OpportunityLineItem>();
        oppLineItem.add(newItem);
		ApexPages.StandardController stdController = new ApexPages.StandardController(opportunityRecord);
		
		Test.startTest();
        OpportunityItem_TriggerHandler oppTriggerHandler = new OpportunityItem_TriggerHandler(true,10);
        opportunityRecord.Start_From__c = 'March';
        update opportunityRecord;
		ApexPages.currentPage().getParameters().put('clone','1');
		OpportunityController controller = new OpportunityController(stdController);
		controller.saveRecords();
        delete opportunityRecord;
        oppTriggerHandler.OnAfterDelete(oppLineItem);
		Test.stopTest();
		
	 }
	 
	 static testMethod void test_Products() {
		Id pricebookId = Test.getStandardPricebookId();
		Product2 product_record = new Product2(Name='Test', Description='Test Product Entry 1');
		insert product_record;
		PricebookEntry standardPrice = new PricebookEntry(
				Pricebook2Id = pricebookId, Product2Id = product_record.Id,
				UnitPrice = 10000, IsActive = true);
		insert standardPrice;
		PricebookEntry pbe = [ SELECT Id,Product2Id,Pricebook2Id,UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :pricebookId AND isActive=true LIMIT 1 ];
		Opportunity_Setting__c setting = new Opportunity_Setting__c();
		setting.Field_Set_Name__c = 'Agency_upsell';
		setting.Record_Type_Name__c = 'Agency_view';
		setting.Record_Type_Group_Name__c = 'Agency';
		setting.name = 'Agency_view';
		insert setting;
		
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
		OpportunityLineItem newItem = new OpportunityLineItem();
		
		newItem.PricebookEntryId = pbe.Id;
		newItem.OpportunityId = opportunityRecord.Id;
		newItem.X1_Month__c = 11;
		newItem.X2_Month__c = 11;
		newItem.X3_Month__c = 11;
		newItem.X4_Month__c = 11;
		newItem.X5_Month__c = 11;
		newItem.X6_Month__c = 11;
		newItem.X7_Month__c = 11;
		newItem.X8_Month__c = 11;
		newItem.X9_Month__c = 11;
		newItem.X10_Month__c = 11;
		newItem.X11_Month__c = 11;
		newItem.X12_Month__c = 11;
		newItem.UnitPrice = 1242141;
		insert newItem;
		
		ApexPages.StandardController stdController = new ApexPages.StandardController(opportunityRecord);
		
		Test.startTest();
		OpportunityProductsController controller = new OpportunityProductsController(stdController);
		Test.stopTest();
		
	 }
	 
	static testMethod void test_OverdueOpportunity() {
		Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
		Map<String,Schema.RecordTypeInfo> recordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
		Id rtId = recordTypeInfo.get('Agency upsell').getRecordTypeId();
		Opportunity	opportunityRecord = new Opportunity();
		opportunityRecord.Start_From__c = 'January';
		opportunityRecord.Name = 'new record';
		opportunityRecord.StageName = 'Initial Discussion';
		opportunityRecord.CloseDate = Date.Today();
		opportunityRecord.RecordTypeId = rtId;
		insert opportunityRecord;
		Batch_OverdueOpportunity job = new Batch_OverdueOpportunity();
		Test.startTest();
		ID batchprocessid = Database.executeBatch(job,1);
		Test.stopTest();
	}
	static testMethod void test_OverdueOpportunityPage() {
		Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
		Map<String,Schema.RecordTypeInfo> recordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
		Id rtId = recordTypeInfo.get('Agency upsell').getRecordTypeId();
		Opportunity	opportunityRecord = new Opportunity();
		opportunityRecord.Start_From__c = 'January';
		opportunityRecord.Name = 'new record';
		opportunityRecord.StageName = 'Initial Discussion';
		opportunityRecord.CloseDate = Date.Today();
		opportunityRecord.RecordTypeId = rtId;
		insert opportunityRecord;
		OverdueOpportunityViewController cont = new OverdueOpportunityViewController();
	}
	
	
	static testMethod void test_OverdueTask() {
		Account accWithBrandAdvert = new Account(Name ='BrandAdvert', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
		accWithBrandAdvert.BillingCity = 'New York';
		accWithBrandAdvert.BillingCountryCode = 'US';
		accWithBrandAdvert.BillingStreet = 'Avenue';
		accWithBrandAdvert.BillingStateCode = 'NY';
		accWithBrandAdvert.BillingPostalCode = '12412';
		insert accWithBrandAdvert;
		Contact con1 = new Contact (LastName ='Singh', AccountId =accWithBrandAdvert.Id);
		con1.MailingCity = 'New York';
		con1.MailingCountryCode = 'US';
		con1.MailingStreet = 'Avenue';
		con1.MailingStateCode = 'NY';
		con1.MailingPostalCode = '12412';
		insert con1;
		String CRON_EXP = '0 0 0 15 3 ? 2022';
		Task t = new Task(Ownerid = UserInfo.getUserId(),Subject = 'Training',Whoid = con1.id, ActivityDate=Date.today());
		insert t; 
		Test.startTest();
		String jobId = System.schedule('JOBNAME',
								CRON_EXP, 
								new Batch_OverdueTasks());
		List<CronTrigger> jobs = [SELECT Id, CronJobDetail.Name, State, NextFireTime FROM CronTrigger where CronJobDetail.Name ='JOBNAME' ];
		System.assert(jobs.size() > 0);
		Test.stopTest();
		
	}
	static testMethod void test_OverdueTaskPage() {
		Account accWithBrandAdvert = new Account(Name ='BrandAdvert', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
		accWithBrandAdvert.BillingCity = 'New York';
		accWithBrandAdvert.BillingCountryCode = 'US';
		accWithBrandAdvert.BillingStreet = 'Avenue';
		accWithBrandAdvert.BillingStateCode = 'NY';
		accWithBrandAdvert.BillingPostalCode = '12412';
		insert accWithBrandAdvert;
		Contact con1 = new Contact (LastName ='Singh', AccountId =accWithBrandAdvert.Id);
		con1.MailingCity = 'New York';
		con1.MailingCountryCode = 'US';
		con1.MailingStreet = 'Avenue';
		con1.MailingStateCode = 'NY';
		con1.MailingPostalCode = '12412';
		insert con1;
		String CRON_EXP = '0 0 0 15 3 ? 2022';
		Task t = new Task(Ownerid = UserInfo.getUserId(),Subject = 'Training',Whoid = con1.id, ActivityDate=Date.today());
		insert t; 
		Test.startTest();
		OverdueTaskViewController cont = new OverdueTaskViewController();
		System.assert(cont.l_tasks.size() > 0);
		Test.stopTest();
	}
	
	static testMethod void test_CompetedTask() {
		Account accWithBrandAdvert = new Account(Name ='BrandAdvert', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
		accWithBrandAdvert.BillingCity = 'New York';
		accWithBrandAdvert.BillingCountryCode = 'US';
		accWithBrandAdvert.BillingStreet = 'Avenue';
		accWithBrandAdvert.BillingStateCode = 'NY';
		accWithBrandAdvert.BillingPostalCode = '12412';
		insert accWithBrandAdvert;
		Contact con1 = new Contact (LastName ='Singh', AccountId =accWithBrandAdvert.Id);
		con1.MailingCity = 'New York';
		con1.MailingCountryCode = 'US';
		con1.MailingStreet = 'Avenue';
		con1.MailingStateCode = 'NY';
		con1.MailingPostalCode = '12412';
		insert con1;
		String CRON_EXP = '0 0 0 15 3 ? 2022';
		Task t = new Task(Ownerid = UserInfo.getUserId(),Subject = 'Training',Whoid = con1.id, ActivityDate=Date.today(), Training_Type__c='TPAS basic training;RTB basic training');
		insert t; 
		Test.startTest();
		t.status = 'Completed';
		update t;
		con1 = [SELECT Trainings_Completed__c FROM Contact WHERE Id = :con1.Id ];
		System.assert(t.Training_Type__c == con1.Trainings_Completed__c);
		Test.stopTest();
	}
}