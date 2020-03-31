/*
    * Name        : ImportData
    * Author        : Dmitrij Marcinkevic
    * Description   : Class generates data
    * Maintenance History:
    * 05/06/2018
*/
public class ImportData {
    public static void initData() {
        List<Account> l_accounts = generateAccounts();
        insert l_accounts;
        /*
        insert generateLeads();
        insert generateContacts(l_accounts);
        insert generatePlatformIds();
        insert generateOpportunities();
        insert generateProductGroups();
        insert generateBillingResource();
        insert generateProducts();
        insert generateProductPrices();
        insert generateContracts();
        insert generateInvoiceTemplates();
        insert generateContractPrices();
        insert generateCases();*/
    }

    /*
     *  @Name - generateAccounts
     *  @Parameters -
     *  @Return Type - List<Account>
     *  @Description - > method generates 20 Accounts
    */
    private static List<Account> generateAccounts(){
        List<Account> l_accounts = new List<Account>();
        List<String> l_typeOfGHG = new List<String>{'Dentsu Aegis Network', 'Havas', 'Omnicom Media Group', 'IPG Mediabrands', 'Publicis', 'WPP'};
        List<String> l_relationshipType = new List<String>{'Agency', 'Publisher', 'Advertiser', 'Creative Agency', 'Consultancy Partner', 'Partner', 'Other'};
        List<String> l_relationshipStatus = new List<String>{'Prospect', 'Trial Agreement', 'Signed', 'Active', 'Inactive', 'Rejected'};
        List<String> l_companyType = new List<String>{'Large Enterprise', 'Medium Enterprise', 'Small Enterprise', 'Startup'};
        List<String> l_lockStatus = new List<String>{'Locked', 'Not Locked'};
        List<String> l_customerTier = new List<String>{'Tier 1', 'Tier 2', 'Tier 3', 'x Other'};
        List<String> l_billingCountry = new List<String>{'United Kingdom', 'United States', 'Germany'};
        List<String> l_contractStatus = new List<String>{'Active', 'Expired', 'Cancelled'};
        List<String> l_agreementType = new List<String>{'MSA', 'TPSA', 'PMSA', 'PPRM', 'Partner'};
        for(Integer i = 1; i <= 20; i++){
            String accName = 'AccountName' + i;
            String navId = String.valueOf(Utilities.generateRandomFromRange(11111, 99999));
            String billCountry = Utilities.findRandomStringFromList(l_billingCountry);
            String currencyCode = 'EUR';
            if(billCountry == 'United Kingdom'){
                currencyCode = 'GBP';
            } else if(billCountry == 'United States'){
                currencyCode = 'USD';
            }
            l_accounts.add(
                new Account(Name = accName,
                        Type_of_GHG__c = Utilities.findRandomStringFromList(l_typeOfGHG),
                        Relationship_Type__c = Utilities.findRandomStringFromList(l_relationshipType),
                        Relationship_Status__c = Utilities.findRandomStringFromList(l_relationshipStatus),
                        Company_Type__c = Utilities.findRandomStringFromList(l_companyType),
                        CurrencyIsoCode = currencyCode,
                        Legal_Company_Name__c = accName,
                        NavisionID__c = navId,
                        Account_Status__c = 'Active',
                        Lock_status__c = Utilities.findRandomStringFromList(l_lockStatus),
                        Customer_Tier__c = Utilities.findRandomStringFromList(l_customerTier),
                        BillingCountry = billCountry,
                        BillingStreet = 'Billing Street',
                        BillingCity = 'Billing City',
                        BillingPostalCode = '2222' + i,
                        ShippingCountry = billCountry,
                        ShippingStreet = 'Billing Street',
                        ShippingCity = 'Billing City',
                        ShippingPostalCode = '2222' + i,
                        Contract_Status__c = Utilities.findRandomStringFromList(l_contractStatus),
                        Agreement_Type__c = Utilities.findRandomStringFromList(l_agreementType),
                        VAT_Number__c = '100000' + i,
                        Registered_Number__c = '100000000' + i,
                        Reminder_terms_code__c = '2',
                        Finance_charge_terms_code__c = '3'
                )
            );
        }
        return l_accounts;
    }

    /*
     *  @Name - generateLeads
     *  @Parameters -
     *  @Return Type - List<Lead>
     *  @Description - method generates 20 Leads
    */
   /* private static List<Lead> generateLeads(){
        List<Lead> l_leads = new List<Lead>();
        List<String> l_leadSource = new List<String>{'Demo requests', 'Newsletter subscriptions', 'Web', 'Webinar registrations', 'Whitepaper / One Pager downloads'};
        List<String> l_status = new List<String>{'New/Unreviewed', 'Initial Contact Made', 'Qualified', 'Unqualified/Closed'};
        for(Integer i = 1; i <= 20; i++){
            l_leads.add(
                new Lead(
                    FirstName = 'FirstName' + i,
                    LastName = 'LastName' + i,
                    LeadSource = Utilities.findRandomStringFromList(l_leadSource),
                    Status = Utilities.findRandomStringFromList(l_status),
                    Company = 'CompanyName' + i
                )
            );
        }
        return l_leads;
    }*/

    /*
     *  @Name - generateContacts
     *  @Parameters - List<Account> l_accountsIn
     *  @Return Type - List<Lead>
     *  @Description - method generates 120 Contacts
    */
   /* private static List<Contact> generateContacts(List<Account> l_accountsIn){
        Integer namesCounter = 1;
        List<Contact> l_contacts = new List<Contact>();
        List<Account> l_accounts = new List<Account>();
        if (l_accountsIn != null && l_accountsIn.size()> 0 ) {
            l_accounts = l_accountsIn;
        }
        else {
            l_accounts = [SELECT Id, BillingCountry, BillingStreet, BillingCity, BillingPostalCode FROM Account];
        }
        
        List<String> l_salesRoles = new List<String>{'Unknown', 'Invoicing Person', 'Invoice Email To', 'Invoice Email CC', 'Reminder Email To', 'Reminder Email CC'};
        for(Account acc : l_accounts){
            for(Integer i = 1; i <= 6; i++){
                l_contacts.add(
                    new Contact(
                        FirstName = 'FirstName' + namesCounter,
                        LastName = 'LastName' + namesCounter,
                        AccountId = acc.Id,
                        Sales_Role__c = l_salesRoles[i-1],
                        Email = 'firstName' + namesCounter + '.' + 'lastName' + namesCounter + '=adform.com@example.com',
                        MailingCountry = acc.BillingCountry,
                        MailingStreet = acc.BillingStreet,
                        MailingCity = acc.BillingCity,
                        MailingPostalCode = acc.BillingPostalCode
                    )
                );
                namesCounter++;
            }
        }
        return l_contacts;
    }*/

    /*
     *  @Name - generatePlatformIds
     *  @Parameters -
     *  @Return Type - List<Platform_ID__c>
     *  @Description - method generates 80 Platform IDs
    */
   /* private static List<Platform_ID__c> generatePlatformIds(){
        List<Platform_ID__c> l_platformIds = new List<Platform_ID__c>();
        List<Account> l_accounts = [SELECT Id FROM Account];
        List<RecordType> l_recordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Platform_ID__c' AND IsActive = true ORDER BY Name];
        for(Account acc : l_accounts){
            for(RecordType item : l_recordType){
                if(item.Name == 'Account ID'){
                    l_platformIds.add(
                            new Platform_ID__c(
                            RecordTypeId = item.Id,
                            Account__c = acc.Id,
                            Account_ID__c = Utilities.generateRandomFromRange(1000, 9999),
                            Billing_Title__c = 'BillingTitle'
                        )
                    );
                } else if(item.Name == 'End Client ID'){
                    l_platformIds.add(
                            new Platform_ID__c(
                            RecordTypeId = item.Id,
                            Account__c = acc.Id,
                            End_Client_ID__c = Utilities.generateRandomFromRange(1000, 9999)
                        )
                    );
                } else if(item.Name == 'Inventory ID'){
                    l_platformIds.add(
                            new Platform_ID__c(
                            RecordTypeId = item.Id,
                            Account__c = acc.Id,
                            Inventory_ID__c = String.valueOf(Utilities.generateRandomFromRange(1000, 9999))
                        )
                    );
                } else {
                    l_platformIds.add(
                            new Platform_ID__c(
                            RecordTypeId = item.Id,
                            Account__c = acc.Id,
                            User_Group_ID__c = Utilities.generateRandomFromRange(1000, 9999)
                        )
                    );
                }
            }
        }
        return l_platformIds;
    }*/

    /*
     *  @Name - generateOpportunities
     *  @Parameters -
     *  @Return Type - List<Opportunity>
     *  @Description - method generates 40 Opportunities
    */
  /*  private static List<Opportunity> generateOpportunities(){
        List<Opportunity> l_opportunities = new List<Opportunity>();
        List<Account> l_accounts = [SELECT Id, CurrencyIsoCode FROM Account];
        List<RecordType> l_recordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Opportunity' AND IsActive = true
            AND Name IN ('Advertiser initial', 'Agency initial', 'Creative Solutions initial', 'Publisher initial')];
        List<String> l_primaryCompetitors = new List<String>{'Not Yet Determined', 'Appnexus', 'DataXu', 'Doubleclick', 'Flashtalking', 'Mediamath', 'Sizmek', 'Turn', 'Undertone',
            'Rubicon', 'Pubmatic', 'Improve Digital', 'Adtech', 'Smart', 'Adition', 'OpenX', 'AdSlot', 'iSocket', 'ShinyAds', 'Enreach', 'The ADEX', 'Krux', 'Relay42', 'Other'};
        List<String> l_stageNames = new List<String>{'Initial Discussion', 'Lead Assessed', 'Proposal Sent', 'Negotiation', 'Legal', 'Contract signed', '100% Activated', 'Closed Lost'};
        Integer opportunityNumber = 1;

        for(Account acc : l_accounts){
            for(Integer i = 1; i <= 2; i++){
                RecordType rt = (RecordType) Utilities.findRandomObjectFromList(l_recordType);
                l_opportunities.add(
                    new Opportunity(
                        RecordTypeId = rt.Id,
                        Name = 'OpportunityName' + opportunityNumber,
                        AccountId = acc.Id,
                        Primary_Competitor__c = Utilities.findRandomStringFromList(l_primaryCompetitors),
                        StageName = Utilities.findRandomStringFromList(l_stageNames),
                        CloseDate = System.today().addYears(1),
                        CurrencyIsoCode = acc.CurrencyIsoCode
                    )
                );
                opportunityNumber++;
            }
        }
        return l_opportunities;
    }*/
//START INSERT Config objects

    /*
     *  @Name - generateProductGroups
     *  @Parameters -
     *  @Return Type - List<Product_Group__c>
     *  @Description - method generates 2 Product Groups
    */
    /*private static List<Product_Group__c> generateProductGroups(){
        List<Product_Group__c> l_productGroup = new List<Product_Group__c>();
        l_productGroup.add(
            new Product_Group__c(
                Name = 'Adserving',
                Is_Active__c = true,
                Information_Section_Label__c = 'Pricing Details',
                Products_Section_Label__c = 'Pricing Rates',
                Show_Payment_Terms__c = true,
                Show_Pricing_Models__c = true,
                Show_Invoice_Level__c = true,
                Show_Invoice_Details__c = true,
                Order__c = 2,
                CurrencyIsoCode = 'EUR',
                Label__c = 'Adserving',
                Payment_Terms__c = '15;30;45;60',
                Available_for_Pricing_model__c = 'Activity Based',
                Default_Payment_Term__c = '15',
                Default_Pricing_Model__c = 'Activity Based'
            )
        );
        l_productGroup.add(
            new Product_Group__c(
                Name = 'Third party tracking with Adform',
                Is_Active__c = true,
                Information_Section_Label__c = 'Pricing Details',
                Products_Section_Label__c = 'Pricing Rates',
                Show_Payment_Terms__c = false,
                Show_Pricing_Models__c = false,
                Show_Invoice_Level__c = false,
                Show_Invoice_Details__c = false,
                Order__c = 2,
                CurrencyIsoCode = 'EUR',
                Label__c = 'Third party tracking with Adform'
            )
        );
        return l_productGroup;
    }*/

    /*
     *  @Name - generateBillingResource
     *  @Parameters -
     *  @Return Type - List<Billing_Resource__c>
     *  @Description - method generates 1 Billing Resource
    */
    /*private static List<Billing_Resource__c> generateBillingResource(){
        List<Billing_Resource__c> l_billingResource = new List<Billing_Resource__c>();
        l_billingResource.add(
            new Billing_Resource__c(
                Name = 'Ad Serving',
                Base_Unit_of_Measure__c = 'IMPR',
                Resource_Number__c = 'NEW ADS',
                Product_Group__c = 'TPAS',
                Gen_Prod_Posting_Group__c = 'SERVICES',
                CurrencyIsoCode = 'EUR'
            )
        );
        return l_billingResource;
    }*/

    /*
     *  @Name - generateProducts
     *  @Parameters -
     *  @Return Type - List<Product__c>
     *  @Description - method generates 4 Products
    */
   /* private static List<Product__c> generateProducts(){
        List<Product__c> l_products = new List<Product__c>();
        List<Product_Group__c> l_productGroups = [SELECT Id FROM Product_Group__c];
        Id billingResourceId = [SELECT Id FROM Billing_Resource__c WHERE Name = 'Ad Serving' LIMIT 1].Id;
        for(Product_Group__c pg : l_productGroups){
            l_products.add(
                new Product__c(
                    Name = 'Basic (< 300 KB)',
                    Measure__c = 'Thousand Impressions',
                    Help_Text__c = 'Any banner type < 300 KB. Minimum price is {0}',
                    Order__c = 1,
                    Product_Group__c = pg.Id,
                    Billing_Resource__c = billingResourceId,
                    Available_For_Pricing_Model__c = 'Activity Based;Activity Based; Net Amount',
                    CurrencyIsoCode = 'EUR',
                    Is_Currency_Included__c = true,
                    Period_Of_Invoicing__c = 'Monthly'
                )
            );
            l_products.add(
                new Product__c(
                    Name = 'Advanced (300 KB - 999 KB)',
                    Measure__c = 'Thousand Impressions',
                    Help_Text__c = 'Any banner type from 300 KB - 999 KB. Minimum price is {0}',
                    Order__c = 2,
                    Product_Group__c = pg.Id,
                    Billing_Resource__c = billingResourceId,
                    Available_For_Pricing_Model__c = 'Activity Based;Activity Based; Net Amount',
                    CurrencyIsoCode = 'EUR',
                    Is_Currency_Included__c = true,
                    Period_Of_Invoicing__c = 'Monthly'
                )
            );
        }
        return l_products;
    }*/

    /*
     *  @Name - generateProductPrices
     *  @Parameters -
     *  @Return Type - List<Product_Price__c>
     *  @Description - method generates 12 Product Prices
    */
   /* private static List<Product_Price__c> generateProductPrices(){
        List<Product_Price__c> l_productPrices = new List<Product_Price__c>();
        List<Product__c> l_products = [SELECT Id FROM Product__c];
        for(Product__c p : l_products){
            l_productPrices.add(
                new Product_Price__c(
                    Name = 'UNITED STATES',
                    Country_Group__c = 'US',
                    Price_Currency__c = 0.116000,
                    Minimum_Price_Currency__c = 0.099000,
                    Available_For_Account_Tier__c = 'Tier 1;Tier 2; Tier 3',
                    CurrencyIsoCode = 'USD',
                    Product__c = p.Id
                )
            );
            l_productPrices.add(
                new Product_Price__c(
                    Name = 'UK',
                    Country_Group__c = 'UK',
                    Price_Currency__c = 0.088000,
                    Minimum_Price_Currency__c = 0.075000,
                    Available_For_Account_Tier__c = 'Tier 1;Tier 2; Tier 3',
                    CurrencyIsoCode = 'GBP',
                    Product__c = p.Id
                )
            );
            l_productPrices.add(
                new Product_Price__c(
                    Name = 'DACH',
                    Country_Group__c = 'DACH',
                    Price_Currency__c = 0.035000,
                    Minimum_Price_Currency__c = 0.030000,
                    Available_For_Account_Tier__c = 'Tier 1;Tier 2; Tier 3',
                    CurrencyIsoCode = 'EUR',
                    Product__c = p.Id
                )
            );
        }
        return l_productPrices;
    }*/

//END INSERT Config objects

    /*
     *  @Name - generateContracts
     *  @Parameters -
     *  @Return Type - List<Contract>
     *  @Description - method generates 60 Contracts
    */
   /* private static List<Contract> generateContracts(){
        List<Contract> l_contracts = new List<Contract>();
        List<RecordType> l_recordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Contract'];
        List<Account> l_accounts = [SELECT Id, Name, Registered_Number__c, NavisionID__c, CurrencyIsoCode, BillingCountry, BillingStreet, BillingCity,
            BillingPostalCode, ShippingCountry, ShippingStreet, ShippingCity, ShippingPostalCode, VAT_Number__c, BillingCountryCode FROM Account];
        Map<String, String> m_opportunities = new Map<String, String>();
        for (Opportunity opp : [Select AccountId, Id from Opportunity])
        {
           m_opportunities.put(opp.AccountId, opp.Id);
        }
        Integer contractNumber = 1;
        Date todayDate = Date.Today();
        Contact contact;

        for(Account acc : l_accounts) {
            for (RecordType rt : l_recordTypes) {
                if (rt.Name == 'BMSA') {
                    l_contracts.add(
                        new Contract(
                            Approver__c = UserInfo.getUserId(),
                            RecordTypeId = rt.Id,
                            AccountId = acc.Id,
                            Name = 'ContractName' + contractNumber,
                            Company_registration_number__c = acc.Registered_Number__c,
                            VAT_number__c = acc.VAT_Number__c,
                            Purchase_orders_PO_numbers__c = 'YES',
                            BillingStreet = acc.BillingStreet,
                            BillingCountryCode = acc.BillingCountryCode,
                            BillingCity = acc.BillingCity,
                            BillingPostalCode = acc.BillingPostalCode,
                            Agreement_type__c = 'BMSA',
                            Effective_date__c = Date.newinstance(todayDate.year(), todayDate.month(), 1)
                        )
                    );
                } else if (rt.Name == 'IO Contact') {
                    contact = [SELECT Id, Email FROM Contact WHERE AccountId = :acc.Id LIMIT 1];
                    l_contracts.add(
                        new Contract(
                            Approver__c = UserInfo.getUserId(),
                            RecordTypeId = rt.Id,
                            Order_date__c = todayDate,
                            Contract_NavisionId_Account__c = acc.NavisionID__c,
                            AccountId = acc.Id,
                            Opportunity__c = m_opportunities.get(acc.Id),
                            CustomerSignedId = contact.Id,
                            CustomerSignedTitle = 'Customer Signed Title',
                            Full_company_name__c = acc.Name,
                            Company_registration_number__c = acc.Registered_Number__c,
                            VAT_number__c = acc.VAT_Number__c,
                            Client_Internal_Order_Number_Needed__c = 'NO',
                            Client_s_contact_name__c = contact.Id,
                            Client_s_contact_e_mail__c = contact.Email,
                            Billing_contact_name_position__c = contact.Id,
                            Invoicing_e_mail__c = contact.Email,
                            Format__c = 'format',
                            Advertiser__c = 'advertiser',
                            Number_of_ordered_units__c = '10',
                            Devices__c = 'Desktop',
                            CurrencyIsoCode = acc.CurrencyIsoCode,
                            Price_for_creative_production__c = 100.00,
                            BillingCountry = acc.BillingCountry,
                            BillingStreet = acc.BillingStreet,
                            BillingCity = acc.BillingCity,
                            BillingPostalCode = acc.BillingPostalCode,
                            Status = 'Contract Created'
                        )
                    );
                } else if (rt.Name == 'MSA Doxis') {
                    l_contracts.add(
                        new Contract(
                            Approver__c = UserInfo.getUserId(),
                            RecordTypeId = rt.Id,
                            AccountId = acc.Id,
                            Status = 'Contract Created',
                            VAT_number__c = acc.VAT_Number__c,
                            Company_registration_number__c = acc.Registered_Number__c,
                            Contract_NavisionId_Account__c = acc.NavisionID__c,
                            Opportunity__c = m_opportunities.get(acc.Id),
                            CurrencyIsoCode = acc.CurrencyIsoCode,
                            Effective_date__c = Date.newinstance(todayDate.year(), todayDate.month(), 1),
                            Services_Payment_Terms__c = '30',
                            BillingCountry = acc.BillingCountry,
                            BillingStreet = acc.BillingStreet,
                            BillingCity = acc.BillingCity,
                            BillingPostalCode = acc.BillingPostalCode,
                            ShippingCountry = acc.ShippingCountry,
                            ShippingStreet = acc.ShippingStreet,
                            ShippingCity = acc.ShippingCity,
                            ShippingPostalCode = acc.ShippingPostalCode
                        )
                    );
                }
                contractNumber++;
            }
        }
        return l_contracts;
    }*/

    /*
     *  @Name - generateInvoiceTemplates
     *  @Parameters -
     *  @Return Type - List<Invoice_Template__c>
     *  @Description - method generates 40 Invoice Templates
    */
  /*  private static List<Invoice_Template__c> generateInvoiceTemplates(){
        List<Invoice_Template__c> l_invoiceTemplates = new List<Invoice_Template__c>();
        List<Product_Group__c> l_productGroups = [SELECT Id FROM Product_Group__c];
        List<Account> l_accounts = [SELECT Id, CurrencyIsoCode FROM Account];
        List<String> l_fileTypes = new List<String>{'Master Data', 'RTB', 'SE Integrations', 'TPAS', 'Pixel Apps', 'Creative service'};
        List<String> l_invoiceDetails;
        List<String> l_invoiceLevels = new List<String>{'Agency', 'End Client', 'Campaign'};
        Map<String, String> m_contracts = new Map<String, String>();
        String invoiceLevel;
        String fileType;
        for(Contract contract : [SELECT AccountId, Id FROM Contract WHERE RecordType.Name = 'BMSA']){
            m_contracts.put(contract.AccountId, contract.Id);
        }
        for(Account acc : l_accounts){
            invoiceLevel = Utilities.findRandomStringFromList(l_invoiceLevels);
            fileType = Utilities.findRandomStringFromList(l_fileTypes);
            if(invoiceLevel == 'Agency' && fileType != 'Creative service'){
                l_invoiceDetails = new List<String>{'Minimal (agency level)', 'Medium (end client level)', 'Maximum (campaign level)'};
            } else if(invoiceLevel == 'End Client'  && fileType != 'Creative service'){
                l_invoiceDetails = new List<String>{'Medium (end client level)', 'Maximum (campaign level)'};
            } else if(invoiceLevel == 'Campaign' || fileType == 'Creative service'){
                l_invoiceDetails = new List<String>{'Maximum (campaign level)'};
            }
            for(Product_Group__c pg : l_productGroups) {
                l_invoiceTemplates.add(
                    new Invoice_Template__c(
                        Product_Group__c = pg.Id,
                        Account__c = acc.Id,
                        File_Type__c = fileType,
                        Payment_Terms_Code__c = '30',
                        Contract__c = m_contracts.get(acc.Id),
                        CurrencyIsoCode = acc.CurrencyIsoCode,
                        Invoice_Details__c = Utilities.findRandomStringFromList(l_invoiceDetails),
                        Invoice_Level__c = invoiceLevel
                    )
                );
            }
        }
        return l_invoiceTemplates;
    }*/

    /*
     *  @Name - generateContractPrices
     *  @Parameters -
     *  @Return Type - List<Contract_Price__c>
     *  @Description - method generates 80 Contract Prices
    */
   /* private static List<Contract_Price__c> generateContractPrices() {
        List<Contract_Price__c> l_contractPrices = new List<Contract_Price__c>();
        List<Invoice_Template__c> l_invoiceTemplates = [SELECT Id, Product_Group__c, Account__c, Contract__c, CurrencyIsoCode FROM Invoice_Template__c];
        List<Product__c> l_products = [SELECT Id, Product_Group__c FROM Product__c];
        List<Product_Price__c> l_productPrices = [SELECT Id FROM Product_Price__c];
        Id billingResourceId = [SELECT Id FROM Billing_Resource__c WHERE Name = 'Ad Serving' LIMIT 1].Id;
        Map<Id, List<Product__c>> m_productGroups = new Map<Id, List<Product__c>>();
        for(Product__c item : l_products){
            List<Product__c> l_temp = new List<Product__c>();
            if (m_productGroups.containsKey(item.Product_Group__c) == true) {
                l_temp = m_productGroups.get(item.Product_Group__c);
            }
            l_temp.add(item);
            m_productGroups.put(item.Product_Group__c, l_temp);
        }
        for (Invoice_Template__c it : l_invoiceTemplates) {
            List<Product__c> l_temp = m_productGroups.get(it.Product_group__c);
            for(Product__c p: l_temp) {
                Product_Price__c productPrice = (Product_Price__c) Utilities.findRandomObjectFromList(l_productPrices);
                l_contractPrices.add(
                    new Contract_Price__c(
                        Account__c = it.Account__c,
                        Billing_Resource__c = billingResourceId,
                        Contract__c = it.Contract__c,
                        Starting_Date__c = Date.Today(),
                        Price__c = Utilities.generateRandomFromRange(100, 999),
                        Product_Price__c = productPrice.Id,
                        CurrencyIsoCode = it.CurrencyIsoCode
                    )
                );
            }
        }
        return l_contractPrices;
    }*/

    /*
     *  @Name - generateCases
     *  @Parameters -
     *  @Return Type - List<Case>
     *  @Description - method generates 60 Cases
    */
    /*private static List<Case> generateCases(){
        String country;
        Integer count = 0;
        List<Case> l_cases = new List<Case>();
        List<RecordType> l_recordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND IsActive = true];
        List<Account> l_account = [SELECT Id, CurrencyIsoCode, (SELECT ID, EMAIL FROM Contacts LIMIT 1) FROM Account];
        List<String> l_countries = new List<String>{'United Kingdom', 'Germany'};
        List<Opportunity> l_opportunities = [SELECT Id, AccountId FROM Opportunity];
        List<Contract> l_contracts = [SELECT Id, AccountId FROM Contract WHERE RecordType.Name = 'IO Contact'];
        Map<String, String> m_opportunities = new Map<String, String>();
        Map<String, String> m_contracts = new Map<String, String>();
        for(Opportunity opp : l_opportunities){
            if (m_opportunities.containsKey(opp.AccountId) != true){
                m_opportunities.put(opp.AccountId, opp.Id);
            }
        }
        for(Contract contract : l_contracts){
            if(m_contracts.containsKey(contract.AccountId) != true){
                m_contracts.put(contract.AccountId, contract.Id);
            }
        }

        for(Account acc : l_account) {
            for (RecordType rt : l_recordTypes) {
                if (rt.Name == 'Creative Production Order') {
                    List<String> l_statuses = new List<String>{'Sent for signature', 'Signed and start production', 'Production done and ready to bill', 'Signed but delay billing', 'Canceled'};
                    l_cases.add(
                        new Case(
                            RecordTypeId = rt.Id,
                            Status = Utilities.findRandomStringFromList(l_statuses),
                            Case_Currency__c = acc.CurrencyIsoCode,
                            Contract__c = m_contracts.get(acc.Id),
                            Opportunity__c = m_opportunities.get(acc.Id),
                            ContactId = acc.Contacts[0].Id,
                            Campaign_ID__c = String.valueOf(Utilities.generateRandomFromRange(1000, 9999)),
                            Agency_ID__c = String.valueOf(Utilities.generateRandomFromRange(1000, 9999)),
                            Client_ID__c = String.valueOf(Utilities.generateRandomFromRange(1000, 9999))
                        )
                    );
                } else if (rt.Name == 'New Platform Account Request') {
                    List<String> l_statuses = new List<String>{'New | Unreviewed', 'Under Review | Awaiting Admin', 'Closed Resolved', 'Closed Rejected'};
                    String status = Utilities.findRandomStringFromList(l_statuses);
                    Double platformId;
                    if(status == 'Closed Resolved'){
                        platformId = Utilities.generateRandomFromRange(1111, 9999);
                    } else {
                        platformId = null;
                    }
                    if(acc.CurrencyIsoCode == 'USD'){
                        country = 'United States of America';
                    } else {
                        country = null;
                    }
                    l_cases.add(
                        new Case(
                            RecordTypeId = rt.Id,
                            Platform_Account_Name__c = 'Platform Account' + count,
                            Service_Agreement_Name__c = 'Service Agreement' + count,
                            Country_Platform_Account__c = country != null ? country : Utilities.findRandomStringFromList(l_countries),
                            Heavy_banner_limit__c = 100.00,
                            AccountId = acc.Id,
                            RTB__c = 'YES',
                            RTB_Limit__c = 2000.00,
                            Name_Surname__c = 'Name Surname' + count,
                            Email__c = acc.Contacts[0].Email,
                            RTB_Rights__c = 'YES',
                            All_client_access__c = 'YES',
                            Admin_rights__c = 'YES',
                            Trading_Desk_Fee__c = 'YES',
                            Status = status,
                            ContactId = acc.Contacts[0].Id,
                            Platform_ID__c = platformId
                        )
                    );
                } else if (rt.Name == 'Salesforce Support'){
                    List<String> l_statuses = new List<String>{'New | Unreviewed', 'Under Review | Awaiting Admin', 'Under Review | Awaiting Submitter',
                        'Executive Review', 'Closed Rejected', 'Closed Duplicate', 'Possible Future Project/Enhancement'};
                    List<String> l_priority = new List<String>{'High', 'Medium', 'Low'};
                    l_cases.add(
                        new Case(
                            Primary_User_Stakeholder__c = UserInfo.getUserId(),
                            Prevented_from_working__c = 'No',
                            Origin = 'User Created',
                            Country__c = acc.Id,
                            Status = Utilities.findRandomStringFromList(l_statuses),
                            Priority = Utilities.findRandomStringFromList(l_priority),
                            ContactId = acc.Contacts[0].Id
                        )
                    );
                }
            }
        }
        return l_cases;
    }*/
}