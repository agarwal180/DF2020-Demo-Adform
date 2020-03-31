/* 
  * Name    : BillingIntegration 
  * Author  : Andrei Pruzan
  * Description   : Class used to retrieve information about accounts & related objects in JSON format
  * Maintenance History: 2/1/2017
*/
global class BillingIntegration {

    // set which used in soql query for accounts 
    public final static set<String> s_roles = new Set<String>{'Invoice Email CC','Invoice Email To', 'Reminder Email CC','Reminder Email To'};
    /* 
        @Name           - getAllAccountIds
        @Parameter      - 
        @Return Type    - json String
        @Description    - this method return all avaialbe account ids
    */
    webService static String getAllAccountIds(){
        List<Account> l_accounts = [SELECT ID FROM Account];
        return  convertToIdJson(l_accounts);
    }
    /* 
        @Name           - getAllAccountIdsFromLastModifiedDate
        @Parameter      - 
        @Return Type    - json String
        @Description    - this method return all avaialbe account ids from specific date time
    */
    webService static String getAllAccountIdsFromLastModifiedDate(DateTime startDate){
        List<Account> l_accounts = [SELECT ID FROM Account WHERE LastModifiedDate >= :startDate];
        return  convertToIdJson(l_accounts);
    }

    /* 
        @Name           - getAllAccountIdsFromLastModifiedDateLegal
        @Parameter      - 
        @Return Type    - json String
        @Description    - this method return all avaialbe account ids from specific date time by legal entities
    */
    webService static String getAllAccountIdsFromLastModifiedDateLegal(DateTime startDate, String legalEntities){
        List<Account> l_accounts = [SELECT ID FROM Account WHERE LastModifiedDate >= :startDate AND  Adform_Legal_Entities__c = : legalEntities];
        return  convertToIdJson(l_accounts);
    }

    /* 
        @Name           - getAllAccountIdsForPeriodLastModifiedDate
        @Parameter      - 
        @Return Type    - json String
        @Description    - this method return all avaialbe account ids for period
    */
    webService static String getAllAccountIdsForPeriodLastModifiedDate(DateTime startDate, DateTime endDate){
        List<Account> l_accounts = [SELECT ID FROM Account WHERE (LastModifiedDate >= :startDate AND LastModifiedDate <= :endDate)];
        return  convertToIdJson(l_accounts);
    }


    /* 
        @Name           - getAllAccountIdsForPeriodLastModifiedDateLegal
        @Parameter      - 
        @Return Type    - json String
        @Description    - this method return all avaialbe account ids for period by legal entities
    */
    webService static String getAllAccountIdsForPeriodLastModifiedDateLegal(DateTime startDate, DateTime endDate, String legalEntities){
        List<Account> l_accounts = [SELECT ID FROM Account WHERE (LastModifiedDate >= :startDate AND LastModifiedDate <= :endDate) AND  Adform_Legal_Entities__c = : legalEntities];
        return  convertToIdJson(l_accounts);
    }


    /* 
        @Name           - getAccountIdsFromDate
        @Parameter      - Date 
        @Return Type    - json String
        @Description    - this method return all avaialbe account ids where Created date more or equal to input param
    */
    webService static String getAccountIdsFromDate(Date startDate){
        List<Account> l_accounts = [SELECT ID FROM Account  WHERE CreatedDate >= :startDate];
        return  convertToIdJson(l_accounts);
    }

    /* 
        @Name           - getAccountIdsForPeriod
        @Parameter      - Date startDate, Date endDate
        @Return Type    - json String
        @Description    - this method return all avaialbe account ids where Created during persion from input params 
    */
    webService static String getAccountIdsForPeriod(Date startDate, Date endDate){
        List<Account> l_accounts = [SELECT ID FROM Account WHERE CreatedDate >= :startDate AND CreatedDate <= :endDate];
        return  convertToIdJson(l_accounts);
    }

    /* 
        @Name           - prepareSOQLQuery
        @Parameter      - 
        @Return Type    - SOQL string
        @Description    - this method prepare soql query sting with all required parasm for json generation 
    */
    public static string prepareSOQLQuery(){
        List<String> l_accountFields = new List<String>{
                'Contract_Company_Name__c',
                'Customer_Tier__c',
                'CurrencyIsoCode',
                'VAT_Number__c',
                'Registered_Number__c',
                'Hide_sales_tax__c',
                'Account_Status__c',
                'ShippingCity',
                'ShippingCountryCode',
                'ShippingPostalCode',
                'ShippingStateCode',
                'ShippingStreet',
                'NavisionID__c',
                'Reminder_terms_code__c',
                'Finance_charge_terms_code__c',
                'Owner.Id',
                'Owner.Navision_Sales_Person_Code__c',
                'Owner.Name',
                'Owner.FirstName',
                'Owner.LastName',
                'Status_Reason__c',
                'Phone',
                'Invoice_Email_Preference__c',
                'Owner.Office__c',
                'Owner.Country_Group__c',
                'Owner.Sales_Country_Group__c',
                'Agency_Group_No__c',
                'Agency_Group_No__r.NavisionID__c',
                'Adform_Legal_Entities__c',
                'Client_Status_Reason__c',
                'Pre_payment__c',
                'Pre_payment_Amount__c',
                'Relationship_Type__c',
                'Status_Effective_Date__c',
                'Responsible_Person__c',
                'Comment__c',
                'LastModifiedDate',
                'Automated_Billing__c'
                };
        List<String> l_contactFields = new List<String>{
                'Name',
                'Email',
                'Sales_Role__c'
                };
        String soqlSTR = 'SELECT '+String.join(l_accountFields, ',');
        soqlSTR+=', (SELECT '+String.join(l_contactFields, ',')+' FROM Contacts WHERE Sales_Role__c IN :s_roles) FROM Account';
        return soqlSTR;
    }

    /* 
        @Name           - getAllAccounts
        @Parameter      - 
        @Return Type    - json String
        @Description    - this method return all accounts in json string
    */
    webService static String getAllAccounts() {
        String strSoql = prepareSOQLQuery();
        List<Account> l_accounts = Database.query(strSoql);
        return  convertToJson(l_accounts);
    }

    /* 
        @Name           - getAccountsbyId
        @Parameter      - List <Id>
        @Return Type    - json String
        @Description    - this method return  accounts for specified list of ids in json string 
    */
    webService static String getAccountsbyId(List<Id> s_ids){
        String strSoql = prepareSOQLQuery();
        strSoql+=' WHERE ID IN:s_ids';
        List<Account> l_accounts = Database.query(strSoql);
        return  convertToJson(l_accounts);
    }

    /* 
        @Name           - getAccountsFromDateByCreatedDate
        @Parameter      - DateTime 
        @Return Type    - json String
        @Description    - this method return all avaialbe account  where Created date more or equal to input param
    */
    webService static String getAccountsFromDateByCreatedDate(DateTime startDate){
        String strSoql = prepareSOQLQuery();
        strSoql+=' WHERE CreatedDate >= :startDate';
        List<Account> l_accounts = Database.query(strSoql);
        return  convertToJson(l_accounts);
    }

    /* 
        @Name           - getAccountsForPeriodCreatedDate
        @Parameter      - DateTime startDate, DateTime endDate 
        @Return Type    - json String
        @Description    - this method return all accounts in json string where created date in Period from start and end date
    */
    webService static String getAccountsForPeriodCreatedDate(DateTime startDate, DateTime endDate){
        String strSoql = prepareSOQLQuery();
        strSoql+=' WHERE CreatedDate >= :startDate AND CreatedDate <= :endDate';
        List<Account> l_accounts = Database.query(strSoql);
        return  convertToJson(l_accounts);
    }

    /* 
        @Name           - getAccountsFromDateByLastModifiedDate
        @Parameter      - Date 
        @Return Type    - json String
        @Description    - this method return all accounts in json string where LastModifiedDate  more or equal to input param
    */
    webService static String getAccountsFromDateByLastModifiedDate(DateTime startDate){
        // check if related contract hav  been changed
        Set<Id> s_accountIds = new Set<Id>();
        for(Contract item : [SELECT AccountID FROM Contract WHERE LastModifiedDate >= :startDate]) {
            s_accountIds.add(item.AccountId);
        }
        String strSoql = prepareSOQLQuery();
        strSoql+=' WHERE (LastModifiedDate >= :startDate OR (Id IN :s_accountIds))';
        List<Account> l_accounts = Database.query(strSoql);
        return  convertToJson(l_accounts);
    }

    /* 
        @Name           - getAccountsFromDateByLastModifiedDate
        @Parameter      - Date 
        @Return Type    - json String
        @Description    - this method return all accounts in json string where LastModifiedDate  more or equal to input param
    */
    webService static String getAccountsFromDateByLastModifiedDateLegal(DateTime startDate, String legalEntities){

        String strSoql = prepareSOQLQuery();
        strSoql+=' WHERE (LastModifiedDate >= :startDate AND  Adform_Legal_Entities__c = : legalEntities)';
        List<Account> l_accounts = Database.query(strSoql);
        return  convertToJson(l_accounts);
    }

    /* 
        @Name           - getAccountsForPeriodLastModifiedDate
        @Parameter      - Date 
        @Return Type    - json String
        @Description    - this method return all accounts in json string where LastModifiedDate in Period from start and end date
    */
    webService static String getAccountsForPeriodLastModifiedDate(DateTime startDate, DateTime endDate){
        // check if related contract hav  been changed
        Set<Id> s_accountIds = new Set<Id>();
        for(Contract item : [SELECT AccountID FROM Contract WHERE LastModifiedDate >= :startDate AND LastModifiedDate <= :endDate]) {
            s_accountIds.add(item.AccountId);
        }
        String strSoql = prepareSOQLQuery();
        strSoql+=' WHERE ((LastModifiedDate >= :startDate AND LastModifiedDate <= :endDate)  OR (Id IN :s_accountIds))';
        List<Account> l_accounts = Database.query(strSoql);
        return  convertToJson(l_accounts);
    }


    /* 
        @Name           - getAccountsForPeriodLastModifiedDate
        @Parameter      - Date 
        @Return Type    - json String
        @Description    - this method return all accounts in json string where LastModifiedDate in Period from start and end date
    */
    webService static String getAccountsForPeriodLastModifiedDateLegal(DateTime startDate, DateTime endDate, String legalEntities){
        String strSoql = prepareSOQLQuery();
        strSoql+=' WHERE ((LastModifiedDate >= :startDate AND LastModifiedDate <= :endDate)  AND  Adform_Legal_Entities__c = : legalEntities)';
        List<Account> l_accounts = Database.query(strSoql);
        return  convertToJson(l_accounts);
    }

    /* 
        @Name           - getAllResources
        @Parameter      -  
        @Return Type    - XML String
        @Description    - this method return all Billing resouces which we have in system with related prices
    */
    webService static String getAllResources() {
        List<Billing_Resource__c> l_resources = [SELECT ID,Base_Unit_of_Measure__c,Name, Gen_Prod_Posting_Group__c,
                Price_Profit_Calculation__c,Profit__c,
                Resource_Number__c,Resource_Recharge_Price__c,
                Type__c,Unit_Cost__c, Unit_Price__c,Product_Group__c, Product__c
                FROM Billing_Resource__c];
        return  convertToXML(l_resources);
    }


    /* 
        @Name           - convertToJson
        @Parameter      - List<Account> l_accounts
        @Return Type    - JSON String
        @Description    - this method convert account array to json str
    */
    public static String convertToJson(List<Account> l_accounts) {
        List<accountJson> l_json_accounts = new List<accountJson>();
        // get all related contracts
        Map<Id,RecordType>  m_recordTypes = new Map<Id, RecordType>([SELECT Id FROM RecordType WHERE DeveloperName IN ('BMSA', 'MSA', 'MSA_Doxis', 'IO') ]);
        List<Contract> l_contracts = [SELECT AccountId,ActivatedById,ActivatedDate,Adform_Sales_Office__c,Ad_serving_fee_included_in_the_bid__c,
                Adform_Sales_Responsible__c,Adserving_Fee__c,Adserving_Type__c,
                Advertiser__c,Agreement_type__c,Approval_Status__c,Automated_Guaranteed__c,
                BillingAddress,BillingCity,BillingCountry,BillingCountryCode,
                BillingGeocodeAccuracy,BillingLatitude,BillingLongitude,
                BillingPostalCode,BillingState,BillingStateCode,BillingStreet,
                Billing_contact_name_position__r.Name,Client_Internal_Order_Number_Needed__c,
                Client_Internal_Order_Number__c,Client_s_contact_e_mail__c,Client_s_contact_name__c,Client_s_contact_name__r.Name,
                Client_with_MSA_PMSA__c,CompanySignedDate,CompanySignedId,Company_registration_number__c,
                ContractNumber,ContractTerm,Country_Group__c,CPM_For_Booked_Impressions_Formula__c,
                CPM_for_booked_impressions__c,CreatedById,CreatedDate,Credit_Limit__c,
                CurrencyIsoCode,CustomerSignedDate,CustomerSignedId,CustomerSignedTitle,
                Customer_type__c,Description,Design_mockup_is_signed_off__c,Devices__c,
                Effective_date__c,EndDate,Format__c,Full_company_name__c,Id,Invoice_details__c,
                Invoice_level__c,Invoice_Type__c,Invoicing_e_mail__c,Invoicing_period__c,IsDeleted,
                Is_HTML5_Rich_Media_included__c,LastActivityDate,LastApprovedDate,LastModifiedById,
                LastModifiedDate,LastReferencedDate,LastViewedDate,Name,Number_of_ordered_units__c,
                Opportunity__c,Order_date__c,Other_information_requirements__c,Other_pricing_details__c,
                OwnerExpirationNotice,OwnerId,Payment_terms__c,Pricebook2Id,Price_for_creative_production_Formula__c,
                Price_for_creative_production__c,Price_for_Reporting_Services__c,Price_for_Trafficking_Services__c,
                Purchase_orders_PO_numbers__c,RecordTypeId, recordType.DeveloperName,Rich_Media_Rate__c,Price_Over_the_limit__c,
                RTB_options__c,RTB_Service_Fees_Included__c,Services__c,ShippingAddress,ShippingCity,
                ShippingCountry,ShippingCountryCode,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,
                ShippingPostalCode,ShippingState,ShippingStateCode,ShippingStreet,SpecialTerms,StartDate,Status,
                Services_Payment_Terms__c, RTB_Payment_Terms__c,
                StatusCode,SystemModstamp,TPAS_fee_on_RTB_form__c,VAT_number__c,
                (SELECT ID, Status, Total_Price_For_Creative_Production__c,
                        CurrencyIsoCode,
                        Invoicing_Period_From__c,
                        Invoicing_Period_To__c,
                        Campaign_ID__c,
                        Agency_ID__c,
                        Client_ID__c,
                        Not_Served_Through_Adform__c, 
                        Campaign_ID_numerical__c,
                        LastModifiedDate,
                        Comments__c FROM Cases__r WHERE Status = 'Production done and ready to bill' AND Contract__r.RecordType.DeveloperName = 'IO'),
                (SELECT Id, Price__c,
                        CurrencyIsoCode,
                        lastModifiedDate,
                        Price_Percent__c,
                        Static__c,
                        Billing_Resource__r.Name,
                        Billing_Resource__r.Resource_Number__c,
                        Billing_Resource__r.Base_Unit_of_Measure__c,
                        Billing_Resource__r.Product_Group__c,
                        Billing_Resource__r.Product__c,
                        Banner_weight_KB_from__c,
                        Banner_weight_KB_to__c,
                        Volume_from__c,
                        Volume_to__c,
                        Unit_of_Measure_Code__c,
                        Starting_Date__c,
                        Ending_Date__c,
                        End_of_Weight_Tier__c,
                        Start_of_Weight_Tier__c,
                        Tier_Type__c,
                        Weight_Tier__c,
                        Tier_Name__c
                        FROM Contract_Prices__r )
                FROM Contract WHERE AccountId IN: l_accounts AND RecordTypeId IN: m_recordTypes.KeySet()];
        // get all related invoice templates for related contracts
        List<Invoice_Template__c> l_templates = [SELECT ID,Invoice_Details__c,Contract__c, File_Type__c, 
                                                    Invoicing_Period__c, Invoice_Level__c,Trading_Desk_Fee__c, 
                                                    Fees_Calculation_model__c, Payment_Terms_Code__c, 
                                                    Payment_Terms_Code_For_Automation__c, Pricing_Model__c,lastModifiedDate,CurrencyIsoCode, RTB_Cost_Split__c,
                (SELECT Id,
                        Price__c,
                        CurrencyIsoCode,
                        lastModifiedDate,
                        Price_Percent__c,
                        Static__c,
                        Billing_Resource__r.Name,
                        Billing_Resource__r.Resource_Number__c,
                        Billing_Resource__r.Base_Unit_of_Measure__c,
                        Billing_Resource__r.Product_Group__c,
                        Billing_Resource__r.Product__c,
                        Banner_weight_KB_from__c,
                        Banner_weight_KB_to__c,
                        Volume_from__c,
                        Volume_to__c,
                        Unit_of_Measure_Code__c,
                        Starting_Date__c,
                        Ending_Date__c,
                        End_of_Weight_Tier__c,
                        Start_of_Weight_Tier__c,
                        Tier_Type__c,
                        Weight_Tier__c,
                        Tier_Name__c
                        FROM Contract_Prices__r )
                FROM Invoice_Template__c WHERE Contract__c IN : l_contracts];
        // get all related Platform Ids for related Accounts
        List<Platform_ID__c> l_platformIds = [SELECT Account__c, Account_ID__c, End_Client_Id__c, User_Group_ID__c, Inventory_ID__c, Start_Date__c, End_Date__c, RecordType.DeveloperName,
                (SELECT Inventory_ID__c FROM Inventory_Source_IDs__r)
                FROM Platform_ID__c
                WHERE Is_Disabled__c = false AND Account__c IN :l_accounts];

        // prepare invoice template map where key = contract id , value = list of related invoice templates
        Map<Id, List<Invoice_Template__c>> m_templates = new Map<Id, List<Invoice_Template__c>>();
        for(Invoice_Template__c it: l_templates) {
            List<Invoice_Template__c> l_temp = new List<Invoice_Template__c>();
            if (m_templates.containsKey(it.Contract__c) == true) {
                l_temp = m_templates.get(it.Contract__c);
            }
            l_temp.add(it);
            m_templates.put(it.Contract__c, l_temp);
        }
        // prepare map of related map where key = Account id, value = list of related contracts 
        Map<Id, List<Contract>> m_contractsToaccount = new Map<Id, List<Contract>> ();
        for(contract c : l_contracts) {
            List<Contract> l_temp = m_contractsToaccount.get(c.AccountId);
            if (l_temp == null) {
                l_temp = new List<Contract>();
            }
            l_temp.add(c);
            m_contractsToaccount.put(c.AccountId, l_temp);
        }
        // prepare map of Platform Ids where key = Account id, value = list of related Platform Ids
        Map<Id, List<Platform_ID__c>> m_platformIdsToAccount = new Map<Id, List<Platform_ID__c>>();
        for(Platform_ID__c pId : l_platformIds){
            List<Platform_ID__c> l_temp = m_platformIdsToAccount.get(pId.Account__c);
            if(l_temp == null){
                l_temp = new List<Platform_ID__c>();
            }
            l_temp.add(pId);
            m_platformIdsToAccount.put(pId.Account__c, l_temp);
        }
        // prepare final list of wrapper classes(used to generate json)
        for(Account a : l_accounts) {
            l_json_accounts.add(new accountJson(a, m_contractsToaccount.get(a.Id), m_templates, m_platformIdsToAccount));
        }
        String output = JSON.serialize(l_json_accounts);
        return output;
    }

    /* 
        @Name           - convertToXML
        @Parameter      - List<Billing_Resource__c> l_InResources
        @Return Type    - XML String
        @Description    - convert salesfroce object 'Billing_Resource__c'  to XML with attirubutes 
    */
    public static String convertToXML(List<Billing_Resource__c> l_InResources) {
        XmlStreamWriter writer = new XmlStreamWriter();
        writer.writeStartDocument('utf-8', '1.0');
        writer.writeStartElement(null, 'resources', null);
        for(Billing_Resource__c br : l_InResources) {
            writer.writeStartElement(null, 'resource', null);
            writer.writeStartElement(null, 'sfdcId', null);
            writer.writeCharacters(Utilities.convertToString(br.Id));
            writer.writeEndElement();
            writer.writeStartElement(null, 'name', null);
            writer.writeCharacters(Utilities.convertToString(br.Name));
            writer.writeEndElement();
            writer.writeStartElement(null, 'navisionServiceCode', null);
            writer.writeCharacters(Utilities.convertToString(br.Resource_Number__c));
            writer.writeEndElement();
            writer.writeStartElement(null, 'baseUnitofMeasure', null);
            writer.writeCharacters(Utilities.convertToString(br.Base_Unit_of_Measure__c));
            writer.writeEndElement();
            writer.writeStartElement(null, 'genProdPostingGroup', null);
            writer.writeCharacters(Utilities.convertToString(br.Gen_Prod_Posting_Group__c));
            writer.writeEndElement();
            writer.writeStartElement(null, 'priceProfitCalculation', null);
            writer.writeCharacters(Utilities.convertToString(br.Price_Profit_Calculation__c));
            writer.writeEndElement();
            writer.writeStartElement(null, 'productNumber', null);
            writer.writeCharacters(Utilities.convertToString(br.Product__c));
            writer.writeEndElement();
            writer.writeStartElement(null, 'productGroup', null);
            writer.writeCharacters(Utilities.convertToString(br.Product_Group__c));
            writer.writeEndElement();
            writer.writeStartElement(null, 'profit', null);
            writer.writeCharacters(Utilities.convertToString(br.Profit__c));
            writer.writeEndElement();
            writer.writeStartElement(null, 'resourceRechargePrice', null);
            writer.writeCharacters(Utilities.convertToString(br.Resource_Recharge_Price__c));
            writer.writeEndElement();
            writer.writeStartElement(null, 'type', null);
            writer.writeCharacters(Utilities.convertToString(br.Type__c));
            writer.writeEndElement();
            writer.writeStartElement(null, 'unitCost', null);
            writer.writeCharacters(Utilities.convertToString(br.Unit_Cost__c));
            writer.writeEndElement();
            writer.writeStartElement(null, 'unitPrice', null);
            writer.writeCharacters(Utilities.convertToString(br.Unit_Price__c));
            writer.writeEndElement();
            writer.writeEndElement();
        }
        writer.writeEndElement();
        writer.writeEndDocument();
        String output = writer.getXmlString();
        writer.close();
        return output;
    }

    /* 
        @Name           - convertToIdJson
        @Parameter      - List<Account> l_accountIds
        @Return Type    - XML String
        @Description    - Convert Salesforce Account objects to JSON Ids
    */
    public static String convertToIdJson(List<Account> l_accountIds) {
        List<AccountId> l_ids = new List<AccountId>();
        for(Account acc : l_accountIds) {
            l_ids.add(new AccountId(acc));
        }
        String output = JSON.serialize(l_ids);
        return output;
    }

    /* 
        @Name           - convertPlatformTools
        @Parameter      - List<Platform_ID__c> l_records
        @Return Type    - List<PlatformIdSON>
        @Description    - Convert List<Platform_ID__c> to List<PlatformIdSON>, PlatformIdSON is a wrapper class
    */
    public static List<PlatformIdSON> convertPlatformTools(List<Platform_ID__c> l_records) {
        List<PlatformIdSON> l_platformIds = new List<PlatformIdSON>();
        for(Platform_ID__c item : l_records) {
            l_platformIds.add(new PlatformIdSON(item));
        }
        return l_platformIds;
    }

    /* 
        Wrapper class used in json generation
    */
    public class AccountId {
        public Id Id;
        public AccountId(Account acc){
            this.Id = acc.Id;
        }
    }

    /* 
        Wrapper class used in json generation, for account object
    */
    public class AccountJSON {
        public Id Id;
        public String companyName;
        public String currencyCode;
        public String vatNumber;
        public String registerNumber;
        public String status;
        public String statusReason;
        public String city;
        public String country;
        public String postalCode;
        public String state;
        public Boolean hideSalesTax;
        public String street;
        public String emailPreference;
        public List<PlatformIdSON> platformIds;
        public List<ContractInfo> contracts;
        public String navisionId;
        public String reminderTermsCode;
        public String financeChargeTermsCode;
        public String phone;
        public SalesPerson salesperson;
        public String accountTier;
        public String agencyGroupCode;
        public List<contactEmail> contacts;
        public String legalEntities;
        //https://adform.atlassian.net/browse/GSS-2218
        public String salesOffice;
        public String salesCountryGroup;
        public String SalesCountryGroupDeprecate;
        //https://adform.atlassian.net/browse/GSS-3026
        public String clientStatusReason;
        public String accountType;
        public Boolean isPrepayment;
        public Decimal prePaymentAmount;
        public Date statusEffectiveDate;
        public String comment;
        public String responsiblePerson;
        public DateTime lastModifiedDate;
        public Boolean automatedBilling;
        public accountJson(Account acc, List<Contract> l_contracts,Map<Id, List<Invoice_Template__c>> m_templates, Map<Id, List<Platform_ID__c>> m_platformIdsToAccount) {
            this.lastModifiedDate = acc.LastModifiedDate;
            this.responsiblePerson = acc.Responsible_Person__c;
            this.comment = acc.Comment__c;
            this.Id = acc.Id;
            this.hideSalesTax = acc.Hide_sales_tax__c;
            this.salesOffice = acc.Owner.Office__c;
            this.statusEffectiveDate = acc.Status_Effective_Date__c;
            this.accountType = acc.Relationship_Type__c;
            this.SalesCountryGroupDeprecate = acc.Owner.Country_Group__c;
            this.salesCountryGroup = acc.Owner.Sales_Country_Group__c;
            this.companyName = acc.Contract_Company_Name__c;
            this.currencyCode = acc.CurrencyIsoCode;
            this.vatNumber = acc.VAT_Number__c;
            this.registerNumber = acc.Registered_Number__c;
            this.status = acc.Account_Status__c;
            this.clientStatusReason = acc.Client_Status_Reason__c;
            this.isPrepayment = acc.Pre_payment__c;
            this.prePaymentAmount = acc.Pre_payment_Amount__c;
            this.statusReason = acc.Status_Reason__c;
            this.emailPreference = acc.Invoice_Email_Preference__c;
            if(m_platformIdsToAccount.get(acc.Id) != null){
                this.platformIds = BillingIntegration.convertPlatformTools(m_platformIdsToAccount.get(acc.Id));
            } else {
                this.platformIds = new List<PlatformIdSON>();
            }
            this.city = acc.ShippingCity;
            this.country = acc.ShippingCountryCode;
            this.postalCode = acc.ShippingPostalCode;
            this.state = acc.ShippingStateCode;
            this.street = acc.ShippingStreet;
            this.navisionId = acc.NavisionID__c;
            this.agencyGroupCode = acc.Agency_Group_No__r.NavisionID__c;
            this.legalEntities = acc.Adform_Legal_Entities__c;
            List<ContractInfo> l_contractInfo = new List<ContractInfo>();
            if (l_contracts != null) {
                for (Contract c : l_contracts) {
                    //if (c.Contract_Prices__r.size() > 0) {
                    l_contractInfo.add(new ContractInfo(c, m_templates));
                    //}
                }
            }
            this.accountTier = acc.Customer_Tier__c;
            this.phone = acc.Phone;
            this.reminderTermsCode = acc.Reminder_terms_code__c;
            this.financeChargeTermsCode = acc.Finance_charge_terms_code__c;
            this.salesperson = new SalesPerson();
            this.salesperson.navisionSalesPersoncode =  acc.Owner.Navision_Sales_Person_Code__c;
            this.salesperson.name =  acc.Owner.Name;
            this.salesperson.firstName =  acc.Owner.FirstName;
            this.salesperson.lastName =  acc.Owner.LastName;
            this.salesperson.Id =  acc.Owner.Id;
            this.contracts = l_contractInfo;
            List<contactEmail> l_contactEmails = new List<contactEmail>();
            for(Contact item : acc.Contacts) {
                l_contactEmails.add(new contactEmail(item));
            }
            this.contacts = l_contactEmails;
            this.automatedBilling = acc.Automated_Billing__c;
        }
    }

    /* 
        Wrapper class used in json generation, for user object. this info set from owner field
    */
    public class SalesPerson {
        public Id Id;
        public String firstName;
        public String lastName;
        public String navisionSalesPersoncode;
        public String name;
    }
    /* 
        Wrapper class used in json generation, for contact object
    */
    public class contactEmail{
        public String contactRole;
        public String email;
        public String name;
        public contactEmail(Contact c){
            this.contactRole = c.Sales_Role__c;
            this.email = c.Email;
            this.name = c.Name;
        }
    }

    /* 
        Wrapper class used in json generation, for Platform_ID__c object
    */
    public class PlatformIdSON{
        public Integer accountId;
        public Integer userGroupId;
        public Integer endClientId;
        public String inventoryId;
        public List<InventorySourceId> inventorySourceIds;
        public Date startDate;
        public Date endDate;
        public Integer dmpId;
        public PlatformIdSON(Platform_ID__c adminTool) {
            if (adminTool.Account_ID__c != null) {
                if('Account_ID'.equals(adminTool.RecordType.DeveloperName)){
                    this.accountId = Integer.valueof(adminTool.Account_ID__c);
                } else if('DMP_ID'.equals(adminTool.RecordType.DeveloperName)){
                    this.dmpId = Integer.valueof(adminTool.Account_ID__c);
                } else if('Sell_Side_ID'.equals(adminTool.RecordType.DeveloperName)){
                    this.inventoryId = String.valueof(adminTool.Account_ID__c);
                }
                
            }
            if (adminTool.User_Group_ID__c != null) {
                this.userGroupId = Integer.valueof(adminTool.User_Group_ID__c);
            }
            if (adminTool.End_Client_Id__c != null && 'End_Client_ID'.equals(adminTool.RecordType.DeveloperName)) {
                this.endClientId = Integer.valueof(adminTool.End_Client_Id__c);
            }
            if (adminTool.Inventory_ID__c != null && 'Inventory_ID'.equals(adminTool.RecordType.DeveloperName)) {
                this.inventoryId = adminTool.Inventory_ID__c;
            }
            List<InventorySourceId> l_inventorySourceInfo = new List<InventorySourceId>();
            for(Inventory_Source_ID__c isId : adminTool.Inventory_Source_IDs__r){
                l_inventorySourceInfo.add(new InventorySourceId(isId));
            }
            this.inventorySourceIds = l_inventorySourceInfo;
            this.startDate = adminTool.Start_Date__c;
            this.endDate = adminTool.End_Date__c;
        }
    }

    /*
        Wrapper class used in json generation, for Inventory_Source_ID__c object
    */
    public class InventorySourceId {
        public String inventorySourceId;
        public InventorySourceId(Inventory_Source_ID__c isid) {
            this.inventorySourceId = isid.Inventory_ID__c;
        }
    }
}