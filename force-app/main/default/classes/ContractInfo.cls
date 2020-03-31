/* 
  * Name    : ContractInfo 
  * Author  : Andrei Pruzan
  * Description   : Class used as a wrapper class for json generation
  * Maintenance History: 2/1/2017
*/
public class ContractInfo{
    public Address invoiceAddress;
    public String currencyIsoCode;
    public String name;
    public Address shippingAddress;
    public String status;
    public Boolean adserving_Fee;
    public String adserving_Type;
    public String advertiser;
    public String agreement_type;
    public Boolean automated_Guaranteed;
    public String billing_contact_name_position;
    public String invoicing_e_mail;
    public Boolean client_with_MSA_PMSA;
    public String client_s_contact_e_mail;
    public String client_s_contact_name;
    public String company_registration_number;
    public Decimal cpm_for_booked_impressions;
    public String customer_type;
    public Date effective_date;
    public String invoice_details;
    public String invoice_level;
    public String invoice_Type;
    public String invoicing_period;
    //
    public String rtbpaymentTerms;
    public String servicePaymentTerms;
    public String invoicePerson;
    //
    public Boolean is_HTML5_Rich_Media_included;
    public String rich_Media_Rate;
    public String rtb_options;
    public Boolean rtb_Service_Fees_Included;
    public List<priceInfo> priceInfo;
    public String services;
    public String vat_number;
    public String priceOverTheLimit;
    public DateTime lastModifiedDate;
    public String id;
    public String contractNumber;
    public List<ContractCase> cases;
    public Boolean adServingFeeIncludedInTheBid;
    public String recordType;
    // 
    public List<InvoiceTemplate> invoiceTemplates;
    
    public ContractInfo(Contract c,Map<Id, List<Invoice_Template__c>> m_templates){
        this.currencyIsoCode = c.currencyIsoCode;
        this.recordType = c.RecordType.DeveloperName;
        this.adServingFeeIncludedInTheBid  = c.Ad_serving_fee_included_in_the_bid__c;
        this.name = c.Name;
        this.status = c.Status;
        this.lastModifiedDate = c.LastModifiedDate;
        this.id = c.Id;
        this.contractNumber = c.ContractNumber;
        this.adserving_Fee = c.Adserving_Fee__c;
        this.adserving_Type = c.Adserving_Type__c;
        this.advertiser = c.Advertiser__c;
        this.agreement_type = c.Agreement_type__c;
        this.automated_Guaranteed = c.Automated_Guaranteed__c;
        this.invoicePerson = c.Billing_contact_name_position__r.Name;
        this.invoicing_e_mail = c.Invoicing_e_mail__c;
        this.client_with_MSA_PMSA = c.Client_with_MSA_PMSA__c;
        this.client_s_contact_e_mail = c.Client_s_contact_e_mail__c;
        this.client_s_contact_name = c.Client_s_contact_name__r.Name;
        this.company_registration_number = c.Company_registration_number__c;
        this.cpm_for_booked_impressions = c.CPM_for_booked_impressions__c;
        this.customer_type = c.Customer_type__c;
        this.effective_date = c.Effective_date__c;
        this.invoice_details = c.Invoice_details__c;
        this.invoice_level = c.Invoice_level__c;
        this.invoice_Type = c.Invoice_Type__c;
        this.invoicing_period = c.Invoicing_period__c;
        this.is_HTML5_Rich_Media_included = c.Is_HTML5_Rich_Media_included__c;
        this.rich_Media_Rate = c.Rich_Media_Rate__c;
        this.rtb_options = c.RTB_options__c;
        this.rtb_Service_Fees_Included = c.RTB_Service_Fees_Included__c;
        List<priceInfo> l_priceInfo = new List<priceInfo>();
        for (Contract_Price__c cp : c.Contract_Prices__r) {
            if (cp.Billing_Resource__c != null) {
                l_priceInfo.add(new priceInfo(cp));
            }
        }
        List<InvoiceTemplate> l_invoiceTemplates = new List<InvoiceTemplate>();
        List<Invoice_Template__c> l_itTemp = new List<Invoice_Template__c>();
        if (m_templates.get(c.Id) != null) {
            l_itTemp = m_templates.get(c.Id);
        }
        for(Invoice_Template__c  it: l_itTemp) {
            l_invoiceTemplates.add(new InvoiceTemplate(it));
        }
        this.invoiceTemplates = l_invoiceTemplates;
        List<ContractCase> l_contractCases = new List<ContractCase>();
        for(Case item : c.Cases__r) {
            l_contractCases.add(new ContractCase(item));
        }
        this.cases = l_contractCases;
        this.priceOverTheLimit = c.Price_Over_the_limit__c;
        this.priceInfo = l_priceInfo;
        this.services = c.Services__c;
        this.vat_number = c.VAT_number__c;
        this.rtbpaymentTerms = c.RTB_Payment_Terms__c;
        this.servicePaymentTerms = c.Services_Payment_Terms__c;
        Address invoiceAddress = new Address();
        invoiceAddress.city = c.BillingCity;
        invoiceAddress.country = c.BillingCountry;
        invoiceAddress.countryCode = c.BillingCountryCode;
        invoiceAddress.postalCode = c.BillingPostalCode;
        invoiceAddress.state = c.BillingState;
        invoiceAddress.stateCode = c.BillingStateCode;
        invoiceAddress.street = c.BillingStreet;
        this.invoiceAddress = invoiceAddress;
        Address shippingAddress = new Address();
        shippingAddress.city = c.ShippingCity;
        shippingAddress.country = c.ShippingCountry;
        shippingAddress.countryCode = c.ShippingCountryCode;
        shippingAddress.postalCode = c.ShippingPostalCode;
        shippingAddress.state = c.ShippingState;
        shippingAddress.stateCode = c.ShippingStateCode;
        shippingAddress.street = c.ShippingStreet;
        this.shippingAddress = shippingAddress;
    }
    /* 
        Wrapper class used in json generation, for Cases information
    */
    public class ContractCase {
        public String status;
        public Decimal totalPrice;
        public String currencyIsoCode;
        public Date invoicePeriodFrom;
        public Date invoicePeriodTo;
        public String campaignId;
        public Integer campaignIdNumber;
        public String agencyId;
        public String clientId;
        public Boolean notServedThroughAdform;
        public String  id;
        public DateTime lastModifiedDate;
        public String comments;
        public ContractCase(Case c){
            this.id = c.Id;
            if (c.Campaign_ID_numerical__c != null) {
                this.campaignIdNumber = Integer.ValueOf(c.Campaign_ID_numerical__c);
            }
            this.comments = c.Comments__c;
            this.lastModifiedDate = c.lastModifiedDate;
            this.status = c.Status;
            this.totalPrice = c.Total_Price_For_Creative_Production__c;
            this.currencyIsoCode = c.CurrencyIsoCode;
            this.invoicePeriodFrom = c.Invoicing_Period_From__c;
            this.invoicePeriodTo = c.Invoicing_Period_To__c;
            this.campaignId = c.Campaign_ID__c;
            this.agencyId = c.Agency_ID__c;
            this.clientId = c.Client_ID__c;
            this.notServedThroughAdform = c.Not_Served_Through_Adform__c;

        }
    }
    /* 
        Wrapper class used in json generation, for Address information
    */
    public class Address {
        public String city;
        public String country;
        public String countryCode;
        public String postalCode;
        public String state;
        public String stateCode;
        public String street;
    }
    /* 
        Wrapper class used in json generation, for Invoice_Template__c object
    */
    public class InvoiceTemplate {
        public List<priceInfo> priceInfo;
        public String paymentTerms;
        public Id id;
        public String invoiceLevel;
        public String invoicePeriod;
        public String invoiceDetail;
        public String templateType;
        public String pricingModel;
        public DateTime lastModifiedDate;
        public String CurrencyIsoCode;
        public String feesCalculationModel;
        public String tradingDescFee;
        public String rtbCostSplit;
        public InvoiceTemplate(Invoice_Template__c it) {
        this.Id = it.Id;
        List<priceInfo> l_priceInfo = new List<priceInfo>();
        for (Contract_Price__c cp : it.Contract_Prices__r) {
            if (cp.Billing_Resource__c != null) {
                l_priceInfo.add(new priceInfo(cp));
            }
        }
        this.tradingDescFee = it.Trading_Desk_Fee__c;
        this.feesCalculationModel = it.Fees_Calculation_model__c;
        this.paymentTerms = it.Payment_Terms_Code_For_Automation__c;
        this.pricingModel = it.Pricing_Model__c;
        this.invoicePeriod = it.Invoicing_Period__c;
        this.invoiceLevel = it.Invoice_Level__c;
        this.invoiceDetail = it.Invoice_Details__c;
        this.templateType = it.File_Type__c;
        this.lastModifiedDate = it.lastModifiedDate;
        this.CurrencyIsoCode = it.CurrencyIsoCode;
        this.priceInfo = l_priceInfo;
        this.rtbCostSplit = it.RTB_Cost_Split__c;
        }
    }
    
    
    /* 
        Wrapper class used in json generation, for Invoice_Template__c object
    */
    public class PriceInfo {
        public String serviceCode;
        public String service_Name;
        public String price_Type;
        public String navisionServiceCode;
        public Decimal value;
        public String baseUnitofMeasure;
        public Decimal pricePercent;
        
        // rich media & impression for tpas
        public String tierType; // additional of main
        public Decimal additionalIncrementSizeKB;
        public Decimal bannerWeightKBfrom;
        public Decimal bannerWeightKBto;
        public Decimal volumeFrom;
        public Decimal volumeTo;
        public String currencyIsoCode;
        public String productNumber;
        public String productGroup;
        public String tierName;

        public Date startingDate;
        public Date endingDate;
        public Id id;
        public DateTime lastModifiedDate;
        
        public PriceInfo(Contract_Price__c price) {
            this.id = price.id;
            this.lastModifiedDate = price.lastModifiedDate;
            this.service_Name = price.Billing_Resource__r.Name;
            this.serviceCode = price.Billing_Resource__r.Resource_Number__c;
            this.productNumber = price.Billing_Resource__r.Product__c;
            this.productGroup = price.Billing_Resource__r.Product_Group__c;
            this.navisionServiceCode = price.Billing_Resource__r.Resource_Number__c;
            this.tierType = price.Tier_Type__c;
            this.tierName = price.Tier_Name__c;
            this.additionalIncrementSizeKB = price.Weight_Tier__c;
            this.bannerWeightKBfrom = (price.Banner_weight_KB_from__c == 0 ? null : price.Banner_weight_KB_from__c);
            this.bannerWeightKBto = (price.Banner_weight_KB_to__c == 0 ? null : price.Banner_weight_KB_to__c);
            this.volumeFrom = price.Volume_from__c;
            this.volumeTo = price.Volume_to__c;
            this.currencyIsoCode = price.CurrencyIsoCode;
            this.baseUnitofMeasure = price.Billing_Resource__r.Base_Unit_of_Measure__c;
            this.startingDate = price.Starting_Date__c;
            this.endingDate = price.Ending_Date__c;
            this.pricePercent = price.Price_Percent__c;
            
            if (price.Billing_Resource__c != null) {
                
                if(price.Billing_Resource__r.Base_Unit_of_Measure__c == 'BUDGET' ) {
                    this.price_Type = 'Percent';
                    if (price.Price__c != null) {
                        this.value = price.Price__c * 100;
                    }
                }
                else {
                    this.price_Type = 'Currency';
                    this.value = price.Price__c;
                }
                
                if(price.Price_Percent__c != null && price_Type == 'Percent'){
                    this.value = price.Price_Percent__c;
                }
            }
        }
  }
  
  
}