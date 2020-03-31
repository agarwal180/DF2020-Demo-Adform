/*
 * Name          : RC_MSAContractController
 * Author        : Andrei Pruzan
 * Description   : Controller for RC_MSAContract page
 * Visulforce page : RC_MSAContract
 * Unit test :
 * Maintenance History:
 * 6/20/2017  - AP - 1.0 - Created.
*/
public with sharing class RC_MSAContractController {
    public Contract contract { get; set; }
    public User currentUser { get; set; }
    public Boolean isEditMode { get; set; }
    public List<SelectOption> contacts { get; set; }
    public List<SelectOption> effectivedays { get; set; }
    public List<SelectOption> emails { get; set; }
    public String countryGroup { get; set; }
    public String contactToemailJson { get; set; }
    public Decimal DefaultValue;
    public String accountTier;
    public Boolean isClone { get; set; }
    public Boolean isVariation { get; set; }
    public Id contractId;
    public Boolean isAutoApprovalNeeded { get; set; }

    // main controller
    public RC_MSAContractController(ApexPages.StandardController con){
        // define contract
        this.contract = (Contract) con.getRecord();
        this.contractId = contract.Id;
        RecordType rt = [SELECT Id FROM Recordtype WHERE developerName = 'BMSA'];
        Id oppId = ApexPages.currentPage().getParameters().get('oppId');
        if (oppId == null && this.contract.Id != null) {
            oppId = [SELECT Opportunity__c FROM Contract WHERE Id =:this.contract.Id].Opportunity__c;
        }
        // define current user
        currentUser = [SELECT ID,Country_Group__c FROM USER WHERE Id =: UserInfo.getUserId()];
        countryGroup = currentUser.Country_Group__c;
        Opportunity oppRecord = [SELECT ID,Name,Account.Name,CurrencyIsoCode, Account.VAT_Number__c,Account.BillingCity, Account.BillingCountry, Account.BillingCountryCode,
                Account.BillingPostalCode, Account.BillingState, Account.BillingStateCode, Account.BillingStreet,
                Account.ShippingCity, Account.ShippingCountry, Account.ShippingCountryCode,
                Account.ShippingPostalCode, Account.ShippingState, Account.ShippingStateCode, Account.ShippingStreet,
                Account.Registered_Number__c,Campaign_Format__c,Account.Customer_Tier__c , AccountId FROM Opportunity WHERE Id=:oppId];

        accountTier = oppRecord.Account.Customer_Tier__c;
        contacts = new List<SelectOption>();
        emails = new List<SelectOption>();
        // if this is new Contract
        isEditMode = false;
        isClone = false;
        isVariation = false;
        isAutoApprovalNeeded = false;
        if (this.contract.Id == null) {
            // get info from Opportunity
            // prefill fields
            this.contract.RTB_Service_Fees_Included__c = true;
            this.contract.RecordTypeId = rt.Id;
            //DefaultValue = (Decimal) Schema.SObjectType.Contract.fields.getMap().get('Monthly_Minimum_Services_Fee__c').getDescribe().getDefaultValue();
            //this.contract.Monthly_Minimum_Services_Fee__c = DefaultValue;
            this.contract.BillingCity = oppRecord.Account.BillingCity;
            this.contract.BillingCountryCode = oppRecord.Account.BillingCountryCode;
            this.contract.BillingPostalCode = oppRecord.Account.BillingPostalCode;
            this.contract.BillingStateCode = oppRecord.Account.BillingStateCode;
            this.contract.BillingStreet = oppRecord.Account.BillingStreet;
            this.contract.ShippingCity = oppRecord.Account.ShippingCity;
            this.contract.ShippingCountryCode = oppRecord.Account.ShippingCountryCode;
            this.contract.ShippingPostalCode = oppRecord.Account.ShippingPostalCode;
            this.contract.ShippingStateCode = oppRecord.Account.ShippingStateCode;
            this.contract.ShippingStreet = oppRecord.Account.ShippingStreet;
            this.contract.Company_registration_number__c = oppRecord.Account.Registered_Number__c;
            this.contract.AccountId = oppRecord.AccountId;
            this.contract.VAT_number__c = oppRecord.Account.VAT_Number__c;
            this.contract.Opportunity__c = oppId;
            this.contract.Credit_Limit__c = 0;
            this.contract.Agreement_type__c = 'BMSA';
            this.contract.RTB_Payment_Terms__c = '15';
            this.contract.Services_Payment_Terms__c = '30';
            // get list of available contacts for contrac creation

            contactToemailJson = '{';
            List<String> l_json = new List<String>();
            for(Contact item : [SELECT Id,Name, Email, title FROM Contact WHERE AccountId =:oppRecord.AccountId]) {
                contacts.add(new SelectOption(item.Id, (String.isBlank(item.title) == false ? item.title : 'Employee') +': '+item.Name));
                if(item.Email != null) {
                    emails.add(new SelectOption(item.Email, item.Email));
                }
                l_json.add('"'+item.Id+'":"'+item.Email+'"');

            }
            contactToemailJson+=String.Join(l_json,',');
            contactToemailJson+='}';

            List<Product_Group__c> l_obPg =  [SELECT ID, Name, Help_Text__c, Label__c,Invoice_Details__c,Read_Only__c, Invoice_Template__c,  Information_Section_Label__c, Products_Section_Label__c,Show_Invoice_Details__c,
                    Default_Pricing_Model__c, Default_Selected_Fees__c,Parent_Product_Group__c,Fixed_Pricing_Model__c,
                    Show_Invoice_Level__c, Show_Payment_Terms__c,Show_Pricing_Models__c, Invoicing_Period__c,
                    Selected_Fees_Calculation_model__c,Available_for_Pricing_model__c, Invoice_Level__c,(SELECT ID FROM Product_Groups__r),
                    (SELECT Id, Default_Payment_Terms__c, Country_Group__c, Available_For_Account_Tier__c, Payment_Terms__c, Maximum_Payment_Terms__c FROM Payment_Terms__r
                            WHERE Country_Group__c INCLUDES (:countryGroup) AND Available_For_Account_Tier__c INCLUDES (:accountTier))
                    FROM Product_Group__c
                    WHERE Is_Active__c = true  ORDER BY Order__c];

            List<Product__c> l_obp = [SELECT ID, Name,Billing_Resource__c,Is_Fixed_Currency__c, Product_Group__c, Help_Text__c,Available_For_Pricing_Model__c, Measure__c,Is_Currency_Included__c,Available_for_Fees_Calculation_model__c,
                    Product_Group__r.Default_Pricing_Model__c, Product_Group__r.Default_Selected_Fees__c,
                    Product_Group__r.Parent_Product_Group__r.Default_Pricing_Model__c, Product_Group__r.Parent_Product_Group__r.Default_Selected_Fees__c,
                    Product_Group__r.Show_Pricing_Models__c,
                    (SELECT ID, CurrencyIsoCode, Price__c,Price_Currency__c,RecordType.Name,Price_percent__c, Minimum_Price_Currency__c, Minimum_Price_Percent__c FROM Product_Prices__r WHERE  Country_Group__c INCLUDES (:currentUser.Country_Group__c) AND Available_For_Account_Tier__c INCLUDES (:accountTier)),
                    (SELECT Id, Billing_Resource__c, Main_Billing_Resource__c FROM Multiple_Billing_Resources__r), Read_Only__c
                    FROM Product__c WHERE Product_Group__c IN :l_obPg  ORDER BY Order__c];
            Map<Id, List<Product__c>> m_productGroups = new Map<Id, List<Product__c>>();
            for(Product__c item : l_obp) {
                List<Product__c> l_temp = new List<Product__c>();
                if (m_productGroups.containsKey(item.Product_Group__c) == true) {
                    l_temp = m_productGroups.get(item.Product_Group__c);
                }
                l_temp.add(item);
                m_productGroups.put(item.Product_Group__c, l_temp);
                for(Product_Price__c pp : item.Product_Prices__r){
                    if(item.Is_Currency_Included__c && pp != null && this.contract.CurrencyIsoCode == null){
                        this.contract.CurrencyIsoCode = pp.CurrencyIsoCode;
                    }
                }
            }

            l_productGroups = new List<ProductGroup>();
            for(Product_Group__c pg : l_obPg) {
                ProductGroup temppg = new ProductGroup(pg, currentUser.Country_Group__c);
                List<Product__c> l_products = m_productGroups.get(pg.Id);
                if (l_products != null && l_products.size() > 0) {
                    List<Product> l_temp = new List<Product>();
                    for(Product__c item : l_products) {
                        if (item.Product_Prices__r.size() > 0 &&
                                (
                                        (item.Product_Group__r.Show_Pricing_Models__c == false && item.Product_Group__r.Parent_Product_Group__r.Default_Pricing_Model__c == null)
                                        ||
                                        (
                                                        item.Available_For_Pricing_Model__c != null &&  item.Available_for_Fees_Calculation_model__c == null &&
                                                (
                                                        (item.Product_Group__r.Default_Pricing_Model__c != null && item.Available_For_Pricing_Model__c.contains(item.Product_Group__r.Default_Pricing_Model__c))
                                                        ||
                                                        (item.Product_Group__r.Parent_Product_Group__r.Default_Pricing_Model__c != null && item.Available_For_Pricing_Model__c.contains(item.Product_Group__r.Parent_Product_Group__r.Default_Pricing_Model__c))
                                                )
                                        )
                                        ||
                                        (
                                                        item.Available_for_Fees_Calculation_model__c != null &&
                                                (
                                                        (item.Product_Group__r.Default_Selected_Fees__c != null && item.Available_for_Fees_Calculation_model__c.contains(item.Product_Group__r.Default_Selected_Fees__c))
                                                        ||
                                                        (item.Product_Group__r.Parent_Product_Group__r.Default_Selected_Fees__c != null && item.Available_for_Fees_Calculation_model__c.contains(item.Product_Group__r.Parent_Product_Group__r.Default_Selected_Fees__c))
                                                )
                                        )

                                )
                        ) {
                            l_temp.add(new Product(item));
                        }
                    }
                    temppg.products = l_temp;
                }
                l_productGroups.add(temppg);
            }
        }
        else {
            List<Invoice_Template__c> l_invoiceTempaltes = [SELECT ID,Fees_Calculation_model__c, Invoice_Details__c, Invoice_Level__c,File_Type__c,
                    Payment_Terms_Code__c, Pricing_Model__c, Product_Group__c,Automated_Billing__c,
                    (SELECT ID,ProductCustom__c,Billing_Resource__c, Product_Price__c, Price__c,Price_Percent__c,Ending_Date__c, Minimum_Price_Currency__c, Minimum_Price_Percent__c, Main_Contract_Price__c FROM Contract_Prices__r ORDER BY ProductCustom__r.Order__c),
                    Maximum_Payment_Terms__c
                    FROM Invoice_Template__c WHERE Contract__c =: this.contract.Id AND End_Date__c = null ORDER BY Product_Group__r.Order__c];
            Set<Id> s_productGroup = new Set<Id>();
            Set<Id> s_relatedPrices = new Set<Id> ();
            for(Invoice_Template__c item : l_invoiceTempaltes) {
                s_productGroup.add(item.Product_Group__c);
                for(Contract_Price__c cp : item.Contract_Prices__r) {
                    s_relatedPrices.add(cp.Product_Price__c);
                }
            }
            Map<Id, Product_Group__c> m_obPg =  new Map<Id, Product_Group__c>([SELECT ID, Name, Read_Only__c, Help_Text__c, Label__c,Invoice_Details__c,Fixed_Pricing_Model__c,
                                                                               Information_Section_Label__c,Invoice_Template__c, Products_Section_Label__c, Show_Invoice_Details__c,
                    Default_Pricing_Model__c, Default_Selected_Fees__c,Parent_Product_Group__c, Invoicing_Period__c,
                    Show_Invoice_Level__c, Show_Payment_Terms__c,Show_Pricing_Models__c, Selected_Fees_Calculation_model__c,Available_for_Pricing_model__c, Invoice_Level__c,
                    (SELECT Id, Default_Payment_Terms__c, Country_Group__c, Available_For_Account_Tier__c, Payment_Terms__c, Maximum_Payment_Terms__c FROM Payment_Terms__r
                            WHERE Country_Group__c INCLUDES (:countryGroup) AND Available_For_Account_Tier__c INCLUDES (:accountTier))
                    FROM Product_Group__c
                    WHERE Id IN:s_productGroup  ORDER BY Order__c]);
            Map<Id, Product__c> m_obp = new Map<Id, Product__c>([SELECT ID, Name,Billing_Resource__c, Product_Group__c, Is_Fixed_Currency__c,
                                                                 Help_Text__c,Available_For_Pricing_Model__c,
                                                                 Measure__c,Is_Currency_Included__c,Available_for_Fees_Calculation_model__c,
                                                                 Product_Group__r.Default_Pricing_Model__c, Product_Group__r.Default_Selected_Fees__c,
                                                                 Product_Group__r.Parent_Product_Group__r.Default_Pricing_Model__c,
                                                                 Product_Group__r.Parent_Product_Group__r.Default_Selected_Fees__c,
                                                                 Product_Group__r.Show_Pricing_Models__c,
                                                                 (SELECT ID, CurrencyIsoCode, Price__c,Price_Currency__c,RecordType.Name,Price_percent__c,
                                                                  Minimum_Price_Currency__c, Minimum_Price_Percent__c FROM Product_Prices__r
                                                                  WHERE  Id IN: s_relatedPrices),
                                                                 (SELECT Id, Billing_Resource__c, Main_Billing_Resource__c FROM Multiple_Billing_Resources__r), Read_Only__c
                                                                 FROM Product__c WHERE Product_Group__c IN :s_productGroup]);
            l_productGroups = new List<ProductGroup>();
            for(Invoice_Template__c it : l_invoiceTempaltes) {
                system.debug('IT==='+it);
                if (m_obPg.get(it.Product_Group__c) != null) {
                    ProductGroup temppg = new ProductGroup(m_obPg.get(it.Product_Group__c), currentUser.Country_Group__c);
                    temppg.invoiceTemplate = it;
                    List<Product> l_temp = new List<Product>();
                    for(Contract_Price__c cp: it.Contract_Prices__r) {
                        system.debug('products ==='+m_obp.get(cp.ProductCustom__c));
                        system.debug('products ==='+cp.ProductCustom__c);
                        if (m_obp.get(cp.ProductCustom__c) != null){
                            Product tempProduct = new Product(m_obp.get(cp.ProductCustom__c));
                            system.debug('product temp=='+tempProduct);
                            if (tempProduct != null && tempProduct.price != null) {
                                tempProduct.contractPrice = cp;
                                if (tempProduct.price.RecordType.Name == 'Currency') {
                                    tempProduct.price.Price__c = cp.Price__c;
                                }
                                else {
                                    tempProduct.price.Price__c = cp.Price_Percent__c;
                                }
                                l_temp.add(tempProduct);
                            }
                        }
                    }
                    temppg.products = l_temp;
                    l_productGroups.add(temppg);
                }
            }
            isEditMode = true;
        }
        Date todayDate = Date.Today();
        String currentDate =  m_dates.get(todayDate.month()) + ' '+ todayDate.year();
        String clone = ApexPages.currentPage().getParameters().get('clone');
        if (clone != null && clone == '1') {
            isClone = true;
        }
        String variation = ApexPages.currentPage().getParameters().get('variation');
        if (variation != null && variation == '1') {
            isVariation = true;
        }
        effectivedays =  new List<SelectOption>{new SelectOption('', '--Please select Date--')};
        if(isClone || isVariation) {
            Contract tempContract = [Select AccountId,ActivatedById, Ad_serving_fee_included_in_the_bid__c ,ActivatedDate,Adform_Legal_Entity__c,
                    Adform_Sales_Office__c,Adform_Sales_Responsible__c,Adserving_Fee__c,Adserving_Type__c,
                    Advertiser__c,Agreement_type__c,Approval_Status__c,Approver__c,Automated_Guaranteed__c,
                    BillingAddress,BillingCity,BillingCountry,BillingCountryCode,BillingGeocodeAccuracy,
                    BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStateCode,
                    BillingStreet,Billing_contact_name_position__c,Client_Internal_Order_Number_Needed__c,
                    Client_Internal_Order_Number__c,Client_s_contact_e_mail__c,Client_s_contact_name__c,
                    Client_with_MSA_PMSA__c,Comments__c,CompanySignedDate,CompanySignedId,Company_registration_number__c,
                    ContractNumber,ContractTerm,Contract_NavisionId_Account__c,Country_Group__c,
                    CPM_For_Booked_Impressions_Formula__c,CPM_for_booked_impressions__c,CreatedById,
                    CreatedDate,Credit_Limit__c,CurrencyIsoCode,CustomerSignedDate,CustomerSignedId,
                    CustomerSignedTitle,Customer_type__c,Description,Design_mockup_is_signed_off__c,
                    Devices__c,Doxis_Document__c,Doxis_Id__c,Doxis_Request__c,Effective_date__c,
                    EndDate,Format__c,Full_company_name__c,Highest_Payment_Terms_Code__c,Id,
                    Invoice_details__c,Invoice_level__c,Invoice_Type__c,Invoicing_e_mail__c,Invoicing_period__c,
                    IsDeleted,Is_Approval_needed_Contract_prices__c,Is_Approval_needed_Payment_terms__c,
                    Is_HTML5_Rich_Media_included__c,LastActivityDate,LastApprovedDate,LastModifiedById,
                    LastModifiedDate,LastReferencedDate,LastViewedDate,Monthly_Minimum_Services_Fee__c,
                    Name,Number_of_ordered_units__c,Opportunity__c,Order_date__c,Other_information_requirements__c,
                    Other_pricing_details__c,OwnerExpirationNotice,OwnerId,Payment_terms__c,Pre_payment_Amount__c,
                    Pre_payment__c,Pricebook2Id,Price_for_creative_production_Formula__c,Price_for_creative_production__c,
                    Price_for_Reporting_Services__c,Price_for_Trafficking_Services__c,Price_Over_the_limit__c,
                    Purchase_orders_PO_numbers__c,RecordTypeId,Rich_Media_Rate__c,RTB_options__c,
                    RTB_Payment_Terms__c,RTB_Service_Fees_Included__c,Services_covered_By_Fixed_Fee__c,
                    Services_Payment_Terms__c,Services__c,ShippingAddress,ShippingCity,
                    ShippingCountry,ShippingCountryCode,ShippingGeocodeAccuracy,ShippingLatitude,
                    ShippingLongitude,ShippingPostalCode,ShippingState,ShippingStateCode,ShippingStreet,
                    SpecialTerms,StartDate,Status,StatusCode,Supplement_Type__c,SystemModstamp,
                    Total_Minimum_Price__c,Total_Price__c,TPAS_fee_on_RTB_form__c,Trading_Desk_Fee__c,
                    VAT_number__c, Minimum_Fee_Period__c From Contract WHERE Id =: contract.Id];
            if(isVariation) {
                isEditMode = true;
            }
            else {
                isEditMode = false;
            }
            contract = tempContract.clone(false, true, false,false);
            contract.Approval_Status__c = 'Approved';
            contract.Status = 'Contract Created';
            contactToemailJson = '{';
            List<String> l_json = new List<String>();
            for(Contact item : [SELECT Id,Name, Email, title FROM Contact WHERE AccountId =:contract.AccountId]) {
                contacts.add(new SelectOption(item.Id, (String.isBlank(item.title) == false ? item.title : 'Employee') +': '+item.Name));
                if(item.Email != null) {
                    emails.add(new SelectOption(item.Email, item.Email));
                }
                l_json.add('"'+item.Id+'":"'+item.Email+'"');

            }
            contactToemailJson+=String.Join(l_json,',');
            contactToemailJson+='}';
            if (tempContract.Effective_date__c != null) {
                currentDate =  m_dates.get(tempContract.Effective_date__c.month()) + ' '+ tempContract.Effective_date__c.year();
            }
        }


        if (todayDate > Date.newinstance(todayDate.year(), todayDate.month(), 1)) {
            todayDate = Date.newinstance(todayDate.year(), todayDate.month(), 1).addMonths(1);
        }
        for(Integer i=1; i<12; i++){
            String monthvalue = m_dates.get(todayDate.month()) + ' '+ todayDate.year();
            effectivedays.add(new SelectOption(todayDate.format(), monthvalue));
            todayDate = todayDate.addMonths(1);
        }

    }


    public PageReference changeAccount() {
        String accName = ApexPages.currentPage().getParameters().get('accName');
        emails = new List<SelectOption>();
        contacts = new List<SelectOption>();
        contactToemailJson = '{';
        List<String> l_json = new List<String>();
        for(Contact item : [SELECT Id,Name, Email, title FROM Contact WHERE Account.Name =:accName]) {
            contacts.add(new SelectOption(item.Id, (String.isBlank(item.title) == false ? item.title : 'Employee') +': '+item.Name));
            if(item.Email != null) {
                emails.add(new SelectOption(item.Email, item.Email));
            }
            l_json.add('"'+item.Id+'":"'+item.Email+'"');

        }
        contactToemailJson+=String.Join(l_json,',');
        contactToemailJson+='}';
        return null;
    }

    public Map<Integer, String> m_dates = new Map<Integer, String>{
    1 => '1st of January',
    2 => '1st of February',
    3 => '1st of March',
    4 => '1st of April',
    5 => '1st of May',
    6 => '1st of June',
    7 => '1st of July',
    8 => '1st of August',
    9 => '1st of September',
    10 => '1st of October',
    11 => '1st of November',
    12 => '1st of December'
    };


    public static List<SelectOption> prepareSelection(String inParams, String fieldName, String userGroup) {
        Set<String> s_nordic = new Set<String>{'DK','SE','NO','FI'};
        List<SelectOption> l_options = new List<SelectOption> ();
        if(inParams != null) {
            List<String> l_values = inParams.split(';');
            if(l_values.size() > 0) {
                l_options = new List<SelectOption>{new SelectOption('', '--None--')};
                if (fieldName == 'Available_for_Pricing_model__c') {
                    for(String item : l_values) {
                        if (item == 'Net Amount' && s_nordic.contains(userGroup)) {
                            l_options.add(new SelectOption(item, item));
                        }
                        else if (item != 'Net Amount') {
                            l_options.add(new SelectOption(item, item));
                        }

                    }

                }
                else {
                    for(String item : l_values) {
                        l_options.add(new SelectOption(item, item));
                    }
                }

            }
        }
        return l_options;
    }

    public class ProductGroup{
        public Product_Group__c productGroup { get; set; }
        public Boolean isCustom { get; set; }
        public Invoice_Template__c invoiceTemplate { get; set; }
        public List<SelectOption> l_paymentTerms { get; set; }
        public List<SelectOption> l_pricingModel { get; set; }
        public List<SelectOption> l_fees { get; set; }
        public List<Product> products { get; set; }
        public ProductGroup(Product_Group__c pgroup, string userGroup){
            this.invoiceTemplate = new Invoice_Template__c();
            if(!pgroup.Payment_Terms__r.isEmpty()){
                pgroup.Show_Payment_Terms__c = true;
                for(Payment_Term__c item : pgroup.Payment_Terms__r){
                    if(item.Payment_Terms__c != null){
                        this.l_paymentTerms = RC_MSAContractController.prepareSelection(item.Payment_Terms__c, null,userGroup);
                    }
                    if(item.Default_Payment_Terms__c != null){
                        this.invoiceTemplate.Payment_Terms_Code__c = item.Default_Payment_Terms__c;
                        this.invoiceTemplate.Payment_Term__c = item.Id;
                    }
                    if(item.Maximum_Payment_Terms__c != null){
                        this.invoiceTemplate.Maximum_Payment_Terms__c = Decimal.valueOf(item.Maximum_Payment_Terms__c);
                    }
                    if(pgroup.Help_Text__c != null && item.Maximum_Payment_Terms__c != null){
                        pgroup.Help_Text__c = pgroup.Help_Text__c.replace('{0}', item.Maximum_Payment_Terms__c);
                    }
                }
            }
            else {
                pgroup.Show_Payment_Terms__c = false;
            }
            this.l_pricingModel = RC_MSAContractController.prepareSelection(pgroup.Available_for_Pricing_model__c, 'Available_for_Pricing_model__c',userGroup);
            this.l_fees = RC_MSAContractController.prepareSelection(pgroup.Selected_Fees_Calculation_model__c, null,userGroup);
            this.productGroup = pgroup;
            this.invoiceTemplate.Product_Group__c = pgroup.Id;
            this.products = new  List<Product>();
            if (pgroup.Default_Pricing_Model__c != null) {
                this.invoiceTemplate.Pricing_Model__c = pgroup.Default_Pricing_Model__c;
            }
            if (pgroup.Default_Selected_Fees__c != null) {
                this.invoiceTemplate.Fees_Calculation_model__c = pgroup.Default_Selected_Fees__c;
            }
            if (pgroup.Invoice_Template__c != null) {
                this.invoiceTemplate.File_Type__c = pgroup.Invoice_Template__c;
            }
            if (pgroup.Invoice_Details__c != null) {
                this.invoiceTemplate.Invoice_Details__c = pgroup.Invoice_Details__c;
            }
            if (pgroup.Invoice_Level__c != null) {
                this.invoiceTemplate.Invoice_Level__c = pgroup.Invoice_Level__c;
            }
            /*if (pgroup.Payment_Terms__c != null) {
              this.invoiceTemplate.Payment_Terms_Code__c = String.valueOf(pgroup.Payment_Terms__c);
            }*/

        }

    }

    public class Product  {
        public Product__c product { get; set; }
        public Product_Price__c price { get; set; }
        public Contract_Price__c contractPrice { get; set; }
        public Decimal priceVal { get; set; }
        public String Type { get; set;}
        public String additionalText { get; set; }
        public List<Multiple_Billing_Resource__c> multipleBillingResources { get; set; }
        public Product(Product__c inProduct){
            this.contractPrice = new Contract_Price__c();
            this.product = inProduct;
            system.debug('product info ==='+inProduct);
            if (inProduct.Product_Prices__r != null && inProduct.Product_Prices__r.size() > 0) {
                this.price = inProduct.Product_Prices__r[0];
            }
            if(inProduct.Multiple_Billing_Resources__r != null && inProduct.Multiple_Billing_Resources__r.size() > 0){
                this.multipleBillingResources = inProduct.Multiple_Billing_Resources__r;
            }
            String minimumPrice = '';
            this.Type = this.price.RecordType.Name;
            if (this.price != null) {
                if (this.price.RecordType.Name == 'Currency') {
                    this.price.Price__c = this.price.Price_Currency__c;
                    if (this.price.Minimum_Price_Currency__c != null) {
                        minimumPrice = String.valueof(this.price.Minimum_Price_Currency__c);
                    }
                }
                else {
                    this.price.Price__c = this.price.Price_percent__c;
                    if(this.price.Minimum_Price_Percent__c != null) {
                        minimumPrice = String.valueof(this.price.Minimum_Price_Percent__c);
                    }
                }
            }
            this.additionalText = this.product.Measure__c;
            if (this.product.Is_Currency_Included__c && this.price != null) {
                this.additionalText = this.price.CurrencyIsoCode+' / '+this.product.Measure__c;
            }
            if (String.isNotBlank(minimumPrice)) {
                minimumPrice = minimumPrice +' '+ this.additionalText;
            }

            if (this.product.Help_Text__c != null) {
                this.product.Help_Text__c = this.product.Help_Text__c.replace('{0}',minimumPrice);
            }



        }
    }
    public void getProducts() {
        String recId = ApexPages.currentPage().getParameters().get('recId');
        String priceType = ApexPages.currentPage().getParameters().get('priceType');
        Set<Id> s_productGroupsIds = new Set<Id>();
        List<Product_Group__c>  l_products = [SELECT ID,(SELECT ID FROM Product_Groups__r) FROM Product_Group__c WHERE ID =:recId];
        for(Product_Group__c item : l_products) {
            s_productGroupsIds.add(item.Id);
            for(Product_Group__c child : item.Product_Groups__r) {
                s_productGroupsIds.add(child.Id);
            }
        }
        system.debug('s_productGroupsIds=='+s_productGroupsIds);
        List<Product__c> l_obp = [SELECT ID, Name,Billing_Resource__c, Product_Group__c, Help_Text__c,Is_Fixed_Currency__c, Measure__c,Is_Currency_Included__c,
                (SELECT ID, CurrencyIsoCode, Price__c,Price_Currency__c,RecordType.Name,Price_percent__c, Minimum_Price_Currency__c, Minimum_Price_Percent__c FROM Product_Prices__r  WHERE  Country_Group__c INCLUDES (:currentUser.Country_Group__c) AND Available_For_Account_Tier__c INCLUDES (:accountTier)),
                (SELECT Id, Billing_Resource__c, Main_Billing_Resource__c FROM Multiple_Billing_Resources__r), Read_Only__c
                FROM Product__c WHERE Product_Group__c IN :s_productGroupsIds AND Available_For_Pricing_Model__c  INCLUDES (:priceType) ORDER BY Order__c];

        system.debug('priceType===='+priceType);
        system.debug('l_obp===='+l_obp);
        for(ProductGroup pg: l_productGroups) {
            if (s_productGroupsIds.contains(pg.productGroup.Id)) {
                List<Product> l_temp = new List<Product>();
                if (l_obp.size() > 0) {
                    system.debug('pg.productGroup.Id=='+pg.productGroup.Id);
                    for(Product__c item : l_obp) {
                        if (item.Product_Prices__r.size() > 0 && item.Product_Group__c == pg.productGroup.Id) {
                            l_temp.add(new Product(item));
                        }
                    }
                }
                system.debug('pg.l_temp.Id=='+l_temp);
                pg.products = l_temp;
            }
        }
    }

    public void getProductsByFees(){
        String recId = ApexPages.currentPage().getParameters().get('recId');
        String feeType = ApexPages.currentPage().getParameters().get('feeType');
        String priceType = ApexPages.currentPage().getParameters().get('priceType');
        Set<Id> s_productGroupsIds = new Set<Id>();
        List<Product_Group__c>  l_products = [SELECT ID,(SELECT ID FROM Product_Groups__r) FROM Product_Group__c WHERE ID =:recId];
        for(Product_Group__c item : l_products) {
            s_productGroupsIds.add(item.Id);
            for(Product_Group__c child : item.Product_Groups__r) {
                s_productGroupsIds.add(child.Id);
            }
        }
        system.debug('s_productGroupsIds=='+s_productGroupsIds);
        List<Product__c> l_obp = [SELECT ID, Name,Billing_Resource__c,Is_Fixed_Currency__c, Product_Group__c, Help_Text__c, Measure__c,Is_Currency_Included__c,
                (SELECT ID, CurrencyIsoCode, Price__c,Price_Currency__c,RecordType.Name,Price_percent__c, Minimum_Price_Currency__c, Minimum_Price_Percent__c FROM Product_Prices__r  WHERE  Country_Group__c INCLUDES (:currentUser.Country_Group__c) AND Available_For_Account_Tier__c INCLUDES (:accountTier)),
                (SELECT Id, Billing_Resource__c , Main_Billing_Resource__c FROM Multiple_Billing_Resources__r), Read_Only__c
                FROM Product__c WHERE Product_Group__c IN :s_productGroupsIds AND Available_For_Pricing_Model__c  INCLUDES (:priceType)  AND (Available_for_Fees_Calculation_model__c = null OR Available_for_Fees_Calculation_model__c INCLUDES(:feeType))  ORDER BY Order__c];

        system.debug('feesType===='+feeType);
        system.debug('l_obp===='+l_obp);
        for(ProductGroup pg: l_productGroups) {
            if (s_productGroupsIds.contains(pg.productGroup.Id)) {
                List<Product> l_temp = new List<Product>();
                if (l_obp.size() > 0) {
                    system.debug('pg.productGroup.Id=='+pg.productGroup.Id);
                    for(Product__c item : l_obp) {
                        if (item.Product_Prices__r.size() > 0 && item.Product_Group__c == pg.productGroup.Id) {
                            l_temp.add(new Product(item));
                        }
                    }
                }
                system.debug('pg.l_temp.Id=='+l_temp);
                pg.products = l_temp;
            }
        }
    }

    public List<ProductGroup> l_productGroups { get; set; }



    public PageReference saveAction () {
        /*if (this.contract.Credit_Limit__c == null || this.contract.Credit_Limit__c == 0 || this.contract.Credit_Limit__c< 0) {
           //this.contract.Credit_Limit__c.addError('Maximum monthly transaction limit should be > 0');
           //return null;
       }*/
        if (this.contract.Pre_payment__c && (this.contract.Pre_payment_Amount__c == null || this.contract.Pre_payment_Amount__c <= 0)) {
            this.contract.Pre_payment_Amount__c.addError('This field is mandatory and amount should be bigger than 0.00');
            return null;
        }

        /*if (serviceSelected.size() > 0) {
            this.contract.Services_covered_By_Fixed_Fee__c = String.join(serviceSelected, ';');
        }*/
        /* if(this.contract.Monthly_Minimum_Services_Fee__c == null){
             this.contract.Monthly_Minimum_Services_Fee__c = DefaultValue;
         }*/
        /*if (contract.Id != null && isClone == false) {
            delete [select id from Contract_Price__c where Contract__c =: contract.Id];
        }*/
        List<Invoice_Template__c> l_templates = [SELECT ID, NAME, End_Date__c,
                (SELECT ID, NAME,Ending_Date__c FROM Contract_Prices__r WHERE Ending_Date__c  = null  ORDER BY ProductCustom__r.Order__c)
                FROM Invoice_Template__c WHERE Contract__c =:contractId AND End_Date__c = null ORDER BY Product_Group__r.Order__c];

        List<Invoice_Template__c> l_itBeforeVariationSchedule = [SELECT Id, Invoicing_Period__c FROM Invoice_Template__c WHERE Contract__c = :contractId AND File_Type__c = 'Minimum Fee'];

        Map<String, Approver_List__c > m_approvers = Approver_List__c.getAll();
        contract.Approver__c = null;
        if (m_approvers.get(countryGroup) != null) {
            contract.Approver__c = m_approvers.get(countryGroup).Approver_Id__c;
        }
        if(isVariation){
            contract.Old_Contract__c = contractId;
        }
        upsert contract;
        List<Invoice_Template__c> l_newInvoiceTemplates = new List<Invoice_Template__c>();
        Map<Id, ProductGroup> m_productGroups = new Map<Id, ProductGroup>();
        for(ProductGroup item : l_productGroups) {
            m_productGroups.put(item.productGroup.Id, item);
        }
        for(ProductGroup item : l_productGroups) {
            if (item.products != null && item.products.size() > 0) {
                item.invoiceTemplate.Contract__c = contract.Id;
                item.invoiceTemplate.Start_Date__c = contract.Effective_date__c;
                item.invoiceTemplate.Account__c = contract.AccountId;
                item.invoiceTemplate.CurrencyIsoCode = contract.CurrencyIsoCode;
                if((isVariation || isEditMode || isClone) && item.invoiceTemplate.File_Type__c == 'Minimum Fee'){
                    for(Invoice_Template__c it : l_itBeforeVariationSchedule){
                        item.invoiceTemplate.Invoicing_Period__c = contract.Minimum_Fee_Period__c;
                    }
                } else {
                    item.invoiceTemplate.Invoicing_Period__c = item.productGroup.Invoicing_Period__c;
                }
                //item.invoiceTemplate.Invoicing_Period__c = 'Quarterly';
                if (isClone || isVariation) {
                    item.invoiceTemplate.Id = null;
                }
                ProductGroup parentGroup = m_productGroups.get(item.productGroup.Parent_Product_Group__c);
                if (parentGroup != null) {
                    if (item.productGroup.Fixed_Pricing_Model__c != null) {
                        item.invoiceTemplate.Pricing_Model__c = item.productGroup.Fixed_Pricing_Model__c;
                    }
                    else {
                        item.invoiceTemplate.Pricing_Model__c = parentGroup.invoiceTemplate.Pricing_Model__c;
                    }
                    if (item.invoiceTemplate.File_Type__c == null) {
                        //item.invoiceTemplate.File_Type__c = parentGroup.invoiceTemplate.File_Type__c;
                    }
                    if (item.productGroup.Name != 'Minimum Services Fee' && item.productGroup.Name != 'Master Data Service'){
                        item.invoiceTemplate.Invoice_Details__c = parentGroup.invoiceTemplate.Invoice_Details__c;
                        item.invoiceTemplate.Invoice_Level__c = parentGroup.invoiceTemplate.Invoice_Level__c;
                    }
                    item.invoiceTemplate.Payment_Terms_Code__c = parentGroup.invoiceTemplate.Payment_Terms_Code__c;
                }
                if(item.invoiceTemplate.Id == null && item.invoiceTemplate.File_Type__c == 'RTB' && contract.Trading_Desk_Fee__c == true) {
                    item.invoiceTemplate.Trading_Desk_Fee__c = '100';
                }
                l_newInvoiceTemplates.add(item.invoiceTemplate);
            }
        }
        upsert l_newInvoiceTemplates;
        List<Contract_Price__c> l_newContractPrice = new List<Contract_Price__c>();
        Set<Id> s_alreadyExistingIds = new Set<Id>();
        for(ProductGroup item : l_productGroups) {
            for(Product pitem : item.products) {
                if(pitem.product.Billing_Resource__c == null && pitem.multipleBillingResources != null && !isEditMode && !isClone && !isVariation){
                    for(Multiple_Billing_Resource__c mbr : pitem.multipleBillingResources){
                        Contract_Price__c cp = new Contract_Price__c();
                        if (pitem.price.RecordType.Name == 'Currency') {
                            cp.Price__c = pitem.price.Price__c;
                        }
                        else {
                            cp.Price_Percent__c = pitem.price.Price__c;
                        }
                        cp.Starting_Date__c = contract.Effective_date__c;
                        cp.Minimum_Price_Currency__c = pitem.price.Minimum_Price_Currency__c;
                        cp.Minimum_Price_Percent__c = pitem.price.Minimum_Price_Percent__c;
                        cp.Account__c = contract.AccountId;
                        cp.Invoice_Template__c = item.invoiceTemplate.Id;
                        cp.Contract__c = this.contract.Id;
                        cp.ProductCustom__c = pitem.product.Id;
                        cp.Billing_Resource__c = mbr.Billing_Resource__c;
                        cp.Product_Price__c = pitem.price.Id;
                        if (pitem.product.Is_Fixed_Currency__c == true) {
                            cp.CurrencyIsoCode = pitem.price.CurrencyIsoCode;
                        }
                        else {
                            if(isClone == false && isVariation == false) {
                                cp.CurrencyIsoCode = contract.CurrencyIsoCode;
                            }
                        }

                        cp.Main_Contract_Price__c = String.valueOf(mbr.Main_Billing_Resource__c);
                        l_newContractPrice.add(cp);
                    }
                }
                else {
                    Contract_Price__c cp = pitem.contractPrice;
                    if (pitem.price.RecordType.Name == 'Currency') {
                        cp.Price__c = pitem.price.Price__c;
                    }
                    else {
                        cp.Price_Percent__c = pitem.price.Price__c;
                    }
                    cp.Starting_Date__c = contract.Effective_date__c;
                    cp.Minimum_Price_Currency__c = pitem.price.Minimum_Price_Currency__c;
                    cp.Minimum_Price_Percent__c = pitem.price.Minimum_Price_Percent__c;
                    cp.Account__c = contract.AccountId;
                    if (isClone || isVariation) {
                        cp.id = null;
                    }
                    if (cp.Id == null) {
                        cp.Invoice_Template__c = item.invoiceTemplate.Id;
                        cp.Contract__c = this.contract.Id;
                        cp.ProductCustom__c = pitem.product.Id;
                        if(cp.Billing_Resource__c == null){
                            cp.Billing_Resource__c = pitem.product.Billing_Resource__c;
                        }
                        cp.Product_Price__c = pitem.price.Id;
                        if (pitem.product.Is_Fixed_Currency__c == true) {
                            cp.CurrencyIsoCode = pitem.price.CurrencyIsoCode;
                        }
                        else {
                            if(isClone == false && isVariation == false) {
                                cp.CurrencyIsoCode = contract.CurrencyIsoCode;
                            }
                        }
                    }
                    else {
                        s_alreadyExistingIds.add(cp.Id);
                    }
                    l_newContractPrice.add(cp);
                }
            }
        }
        if (s_alreadyExistingIds.size() > 0 && contractId != null && isClone == false && isVariation == false) {
            delete [SELECT ID FROM Contract_Price__c WHERE Contract__c = :contractId AND ID NOT IN : s_alreadyExistingIds];
        }
        System.debug('111: ' + l_newContractPrice);
        upsert l_newContractPrice;
        Decimal newContractTotalPrice = null;
        Contract newContract = null;
        for(Contract_Price__c contractPrice : l_newContractPrice){
            if(contractPrice.Contract__c != null){
                newContract = [SELECT Id, Total_Price__c,Approval_Status__c, Approver__c  FROM Contract WHERE Id = :contractPrice.Contract__c];
                newContractTotalPrice = newContract.Total_Price__c;
                break;
            }
        }
        //Approval_Status__c == 'Need approval'
        if(newContractTotalPrice != null && contract.Total_Price__c <= newContractTotalPrice){
            isAutoApprovalNeeded = true;
        }
        /*if (newContract != null && newContract.Approval_Status__c == 'Need approval') {
           isAutoApprovalNeeded = true;
        }*/
        if ((isClone || (isVariation && isAutoApprovalNeeded)) && Utilities.getWorkItemId(newContract.Id) != null) {
           UtilitiesWithoutSharing.recordApprove(newContract.Id);
        }

        return new Pagereference('/'+contract.Id);
    }
}
