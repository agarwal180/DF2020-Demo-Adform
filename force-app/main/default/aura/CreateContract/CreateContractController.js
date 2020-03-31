({
	init : function(component, event, helper) {
		helper.getContacts(component);
        helper.getRecordTypes(component);
        helper.getOpportunity(component);
	},
    nextStep : function(component, event, helper) {
		var isFirstStep = component.get("v.isSelectContact");
        var recordTypes = component.get("v.l_recordTypes");
        var selectedRecordType = component.get("v.selectedRT");
        var SelectedContact = component.get("v.SelectedContact");
        var SelectedEmail = component.get("v.SelectedEmail");
        var oppRecord = component.get("v.opp");
        console.log(SelectedContact);
        console.log(SelectedEmail);
        if (isFirstStep == false) {
            var isBMSA = false;
            for(var i = 0; i < recordTypes.length; i++){
                console.log(selectedRecordType);
                console.log(recordTypes[i].Id);
                if (selectedRecordType == recordTypes[i].Id && recordTypes[i].DeveloperName == 'BMSA') {
                    isBMSA = true;
                }
            }
            if (isBMSA == true) {
                
                var url = "/apex/RC_MSAcontract?oppId="+oppRecord.Id;
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": url,
                    "isredirect": false
                });
                urlEvent.fire();
            }
            else {
                component.set("v.isSelectContact", true);
            }
        }
        else {
            var createRecordEvent = $A.get("e.force:createRecord");
             createRecordEvent.setParams({
                "entityApiName": "Contract",
                "defaultFieldValues":{
                    "Opportunity__c" : oppRecord.Id,
                    "AccountId": oppRecord.AccountId,
                    "VAT_Number__c": oppRecord.Account.VAT_Number__c,
                    "Company_registration_number__c" : oppRecord.Account.Registered_Number__c,
                    "CurrencyIsoCode":oppRecord.CurrencyIsoCode,
                    "BillingCountryCode": oppRecord.Account.BillingCountryCode,
                    "BillingStreet" : oppRecord.Account.BillingStreet,
                    "BillingCity": oppRecord.Account.BillingCity,
                    "BillingStateCode": oppRecord.Account.BillingStateCode,
                    "BillingPostalCode" : oppRecord.Account.BillingPostalCode,
                    "Client_s_contact_name__c":SelectedContact,
                    "Client_s_contact_e_mail__c":SelectedEmail,
                    "Billing_contact_name_position__c":SelectedContact,
                    "Invoicing_e_mail__c":SelectedEmail,
                    "Format__c":oppRecord.Campaign_Format__c
                },
                "recordTypeId": selectedRecordType
            });
            createRecordEvent.fire();
            
        
        }
	},
    onGroup: function(component, event) {
		 var selected = event.getSource().get("v.value");
		 component.set("v.selectedRadio", selected);
        console.log(selected);
	 }
})