public with sharing class ContactSelectionForContract {
    public Opportunity oppRecord { get; set; }
    public List<SelectOption> contacts { get; set; }
    public List<SelectOption> emails { get; set; }
    public Id selectedContact { get; set; }
    public String selectedEmail { get; set; }
    public String newURL { get; set; }
    public map<Id, Contact> contactMap ;
    public ContactSelectionForContract(ApexPages.StandardController con){
        this.oppRecord = (Opportunity) con.getRecord();
        oppRecord = [SELECT ID,Name,Account.Name,CurrencyIsoCode, Account.VAT_Number__c,Account.BillingCity, Account.BillingCountry, Account.BillingCountryCode, 
        Account.BillingPostalCode, Account.BillingState, Account.BillingStateCode, Account.BillingStreet,
         Account.Registered_Number__c,Campaign_Format__c, AccountId FROM Opportunity WHERE Id=:oppRecord.Id];
        contactMap = new Map<Id, Contact>([SELECT Id,Name, Email FROM Contact WHERE AccountId =: oppRecord.AccountId]);
        contacts = new List<SelectOption>();
        emails = new List<SelectOption>();
        for(Contact item : contactMap.values()) {
            contacts.add(new SelectOption(item.Id, item.Name));
            if(item.Email != null) {
                emails.add(new SelectOption(item.Email, item.Email));
            }
        }
    }
    public PageReference cancelAction(){
        return new PageReference('/'+oppRecord.Id);
    }
    
    public PageReference SelectInfo() {
    	List<String> l_errors = new List<String>();
	    if(String.isBlank(selectedContact)) {
	      l_errors.add('Contact person is required.');
	    }
	    if(String.isBlank(selectedEmail)) {
	      l_errors.add('Email is required.');
	    }
	    if (l_errors.size() > 0) {
	      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,String.join(l_errors, '; ')));
	      return null;
	    }
        Pagereference newURL = new PageReference('/800/e?');
            Map<String, Field_Setting__c> fieldsMap = Field_Setting__c.getAll();
            String opportunity_field = fieldsMap.get('Contract_Opportunity') != null ? fieldsMap.get('Contract_Opportunity').Field_Id__c : ((Test.isRunningTest()) ? 'test':'');
            String billing_contact_field = fieldsMap.get('Contract_Billing_contact_name') != null ? fieldsMap.get('Contract_Billing_contact_name').Field_Id__c : ((Test.isRunningTest()) ? 'test':'');
            String client_contact_field = fieldsMap.get('Contract_Client_s_contact_name') != null ? fieldsMap.get('Contract_Client_s_contact_name').Field_Id__c : ((Test.isRunningTest()) ? 'test':'');
            String invoice_email_field = fieldsMap.get('Contract_Invoicing_e_mail')  != null ? fieldsMap.get('Contract_Invoicing_e_mail').Field_Id__c : ((Test.isRunningTest()) ? 'test':'');
            String contact_email_field = fieldsMap.get('Contract_Client_s_contact_e_mail') != null ? fieldsMap.get('Contract_Client_s_contact_e_mail').Field_Id__c : ((Test.isRunningTest()) ? 'test':'');
            String account_field = fieldsMap.get('Contract_Full_company_name') != null ? fieldsMap.get('Contract_Full_company_name').Field_Id__c : ((Test.isRunningTest()) ? 'test':'');
            String vat_field = fieldsMap.get('Contract_VAT_number') != null ? fieldsMap.get('Contract_VAT_number').Field_Id__c : ((Test.isRunningTest()) ? 'test':'');
            String number_field = fieldsMap.get('Contract_Registered_Number') != null ? fieldsMap.get('Contract_Registered_Number').Field_Id__c : ((Test.isRunningTest()) ? 'test':'');
            String campaign_format_field = fieldsMap.get('Contract_Campaign_Format') != null ? fieldsMap.get('Contract_Campaign_Format').Field_Id__c : ((Test.isRunningTest()) ? 'test':'');
            if(String.isNotEmpty(opportunity_field)) {
                newURL.getParameters().put('CF'+opportunity_field, oppRecord.Name);
                newURL.getParameters().put('CF'+opportunity_field+'_lkid', oppRecord.Id);
            }
            newURL.getParameters().put('CurrencyIsoCode', oppRecord.CurrencyIsoCode);
            
            if(String.isNotEmpty(oppRecord.Account.Name))  {
                newURL.getParameters().put('ctrc7', oppRecord.Account.Name);
                newURL.getParameters().put('ctrc7_lkid', oppRecord.Account.Id);
            }
            if(selectedContact != null) {
                Contact tempContact = contactMap.get(selectedContact);
                if(String.isNotEmpty(billing_contact_field)) {
                    newURL.getParameters().put('CF'+billing_contact_field, tempContact.Name);
                    newURL.getParameters().put('CF'+billing_contact_field+'_lkid', tempContact.Id);
                }
                if(String.isNotEmpty(client_contact_field)) {
                    newURL.getParameters().put('CF'+client_contact_field, tempContact.Name);
                    newURL.getParameters().put('CF'+client_contact_field+'_lkid', tempContact.Id);
                }
            }
            if(String.isNotEmpty(selectedEmail)) {
                if(String.isNotEmpty(invoice_email_field)) {
                    newURL.getParameters().put(invoice_email_field, selectedEmail);
                }
                if(String.isNotEmpty(contact_email_field)) {
                    newURL.getParameters().put(contact_email_field, selectedEmail);
                }
            }
            if(String.isNotEmpty(oppRecord.Account.Name) && String.isNotEmpty(account_field)) {
                newURL.getParameters().put(account_field, oppRecord.Account.Name);
            }
            if(String.isNotEmpty(oppRecord.Account.VAT_Number__c) && String.isNotEmpty(vat_field)) {
                newURL.getParameters().put(vat_field, oppRecord.Account.VAT_Number__c);
            }
            if(String.isNotEmpty(oppRecord.Account.Registered_Number__c) && String.isNotEmpty(number_field)) {
                newURL.getParameters().put(number_field, oppRecord.Account.Registered_Number__c);
            }
            if(String.isNotEmpty(oppRecord.Campaign_Format__c) && String.isNotEmpty(campaign_format_field)) {
                newURL.getParameters().put(campaign_format_field, oppRecord.Campaign_Format__c);
            }
            
            //Billing info
            if(String.isNotEmpty(oppRecord.Account.BillingCountryCode)) {
                newURL.getParameters().put('ctrc25country', oppRecord.Account.BillingCountryCode);
            }
            if(String.isNotEmpty(oppRecord.Account.BillingStreet)) {
                newURL.getParameters().put('ctrc25street', oppRecord.Account.BillingStreet);
            }
            if(String.isNotEmpty(oppRecord.Account.BillingCity)) {
                newURL.getParameters().put('ctrc25city', oppRecord.Account.BillingCity);
            }
            if(String.isNotEmpty(oppRecord.Account.BillingStateCode)) {
                newURL.getParameters().put('ctrc25state', oppRecord.Account.BillingStateCode);
            }
            if(String.isNotEmpty(oppRecord.Account.BillingPostalCode)) {
                newURL.getParameters().put('ctrc25zip', oppRecord.Account.BillingPostalCode);
            }
        
        return newURL;
    }
}