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
private class ContractBMSA_Test{
    @testSetup static void SetupMethod() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = recordTypeInfo.get('Agency upsell').getRecordTypeId();
        Account accWithBrandAdvert = new Account(Name ='BrandAdvert', Customer_Tier__c ='Tier 1',CurrencyIsoCode='EUR', Relationship_Type__c ='Brand/Advertiser',Brand_Name__c='test', Company_Type__c ='Startup',Is_From_Lead__c  =true);
        Account accWithPublis = new Account(Name ='Publis', Relationship_Type__c ='Publisher', CurrencyIsoCode='EUR', Customer_Tier__c ='Tier 1', Company_Type__c ='Startup', Is_From_Lead__c  =true);
        insert new List<Account>{accWithBrandAdvert, accWithPublis};
        Opportunity opportunityRecord = new Opportunity();
        opportunityRecord.AccountId = accWithBrandAdvert.Id;
        opportunityRecord.Start_From__c = 'January';
        opportunityRecord.Name = 'new record';
        opportunityRecord.StageName = 'Closed';
        opportunityRecord.CloseDate = Date.Today();
        opportunityRecord.RecordTypeId = rtId;
        insert opportunityRecord;
        Product_Group__c pg = new Product_Group__c();
        pg.Name = 'Adserving';
        pg.Default_Payment_Term__c = '30';
        pg.Default_Pricing_Model__c = 'Pure Media';
        pg.Default_Selected_Fees__c = 'Included Fees';
        pg.Information_Section_Label__c = 'On Top Fees';
        pg.Is_Active__c = true;
        pg.Label__c = 'label';
        pg.Order__c = 1;
        pg.Payment_Terms__c = '15; 30; 45; 60';
        pg.Print_Out_Label__c = 'label';
        pg.Products_Section_Label__c = 'label';
        pg.Selected_Fees_Calculation_model__c = 'Included Fees; On Top Fees';
        pg.Available_for_Pricing_model__c = 'Pure media + Data; Gross Platform Spend; Pure Media';
        pg.Show_Invoice_Details__c = true;
        pg.Show_Invoice_Level__c = true;
        pg.Show_Payment_Terms__c = true;
        pg.Show_Pricing_Models__c = true;
        insert pg;
        Product__c product = new Product__c();
        product.Product_Group__c = pg.Id;
        product.Available_for_Fees_Calculation_model__c = 'Included Fees; On Top Fees';
        product.Available_For_Pricing_Model__c = 'Pure media + Data; Gross Platform Spend; Pure Media';
        product.Help_Text__c = 'test {0}';
        product.Is_Currency_Included__c = true;
        product.Measure__c = '%';
        product.Order__c = 1;
        product.Period_Of_Invoicing__c = 'Monthly';
        product.Name = 'product 1';
        insert product;
        Product__c product2 = new Product__c();
        product2.Product_Group__c = pg.Id;
        product2.Available_for_Fees_Calculation_model__c = 'Included Fees; On Top Fees';
        product2.Available_For_Pricing_Model__c = 'Pure media + Data; Gross Platform Spend; Pure Media';
        product2.Help_Text__c = 'test {0}';
        product2.Is_Currency_Included__c = true;
        product2.Measure__c = '%';
        product2.Order__c = 2;
        product2.Period_Of_Invoicing__c = 'Monthly';
        product2.Name = 'product 2';
        insert product2;
        Schema.DescribeSObjectResult ppSchema = Schema.SObjectType.Product_Price__c; 
        Map<String,Schema.RecordTypeInfo> m_productPriceRT = ppSchema.getRecordTypeInfosByName(); 
        List<Product_Price__c> l_productPrice = new List<Product_Price__c>();
        Product_Price__c pp = new Product_Price__c();
        pp.Product__c = product.Id;
        pp.Available_For_Account_Tier__c = 'Tier 1; Tier 2; Tier 3';
        pp.Country_Group__c = 'UK; DACH; IT; NL/BE; IB; CEE; FI; NO; DK; SE; US; BENEFRUX; Baltics; Poland; Turkey; Czech Republic';
        pp.Minimum_Price_Currency__c = 0.323;
        pp.Price_Currency__c = 0.324;
        pp.RecordTypeId = m_productPriceRT.get('Currency').getRecordTypeId();
        l_productPrice.add(pp);
        Product_Price__c pp2 = new Product_Price__c();
        pp2.Product__c = product2.Id;
        pp2.Available_For_Account_Tier__c = 'Tier 1; Tier 2; Tier 3';
        pp2.Country_Group__c = 'UK; DACH; IT; NL/BE; IB; CEE; FI; NO; DK; SE; US; BENEFRUX; Baltics; Poland; Turkey; Czech Republic';
        pp2.Minimum_Price_Percent__c = 1;
        pp2.Price_Percent__c = 1;
        pp2.RecordTypeId = m_productPriceRT.get('Percent').getRecordTypeId();
        l_productPrice.add(pp2);
        insert l_productPrice;
        Contact con1=new Contact();
        con1.LastName='TestLastname';
        con1.Email='abc.test@yahoo.com';
        con1.AccountId=accWithPublis.Id;
        insert con1;
        Billing_Resource__c br=new Billing_Resource__c();
        br.Name='First BR';
        insert br;
        Multiple_Billing_Resource__c mbr=new Multiple_Billing_Resource__c();
        mbr.Name='TEST';
        mbr.Product__c=product.Id;
        mbr.Main_Billing_Resource__c=false;
        mbr.Billing_Resource__c=br.Id;
        insert mbr;
        Contract_Price__c cp=new Contract_Price__c();
        cp.Price__c=100;
        cp.Account__c=accWithBrandAdvert.Id;
        insert cp;
        Invoice_Template__c it=new Invoice_Template__c();
        it.Payment_Terms_Code__c='15';
        insert it;
    }

    @isTest static void contract_creation() {
        Opportunity opp = [select id from Opportunity limit 1];
        Contract contractTemp = new Contract();
        ApexPages.StandardController stdController = new ApexPages.StandardController(contractTemp);
        Test.startTest();
            ApexPages.currentPage().getParameters().put('oppId',opp.Id);
            RC_MSAContractController controller = new RC_MSAContractController(stdController);
            Product_Group__c pg = [SELECT  ID FROM Product_Group__c LIMIT 1];
            Account acc = [SELECT Id FROM Account LIMIT 1];
            ApexPages.currentPage().getParameters().put('recId',pg.Id);
            ApexPages.currentPage().getParameters().put('priceType','Pure media + Data');
            ApexPages.currentPage().getParameters().put('feeType','Included Fees');
            ApexPages.currentPage().getParameters().put('clone','1');
            ApexPages.currentPage().getParameters().put('variation','1');
            controller.getProducts();
            controller.getProductsByFees();
            controller.saveAction();
            contractTemp = [select id from Contract Limit 1];
            ApexPages.StandardController stdControllernew = new ApexPages.StandardController(contractTemp);
            RC_MSAContractController controllernew = new RC_MSAContractController(stdControllernew);
            RC_BMSAPriceController priceInfo = new RC_BMSAPriceController(stdControllernew);
            RC_InvoiceTemplatesHTMLController componentController = new RC_InvoiceTemplatesHTMLController();
            componentController.ContractId = contractTemp.Id;
            componentController.setContractId(contractTemp.Id);
            componentController.getContractId();
            componentController.getTemplates();
            controllernew.changeAccount();
            Contract_Price__c cp = [SELECT ID,Price__c, Account__c FROM Contract_Price__c WHERE Price__c != null LIMIT 1];
            if(cp!=null) {
                cp.Price__c = 1;
                cp.Account__c = acc.Id;
                update cp;
                delete cp;
            }
            Invoice_Template__c it = [SELECT Id ,Payment_Terms_Code__c FROM Invoice_Template__c LIMIT 1];
            if(it != null){
                it.Payment_Terms_Code__c = '30';
                update it;
                delete it;
                delete contractTemp;
            }
        	Test.stopTest();
    }
}