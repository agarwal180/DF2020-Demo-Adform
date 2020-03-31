@RestResource(urlMapping='/DoxisIntegration/*')
global with sharing class RESTDoxisIntegration {

@HttpPost	 
	global static String createNewContract() {
		RestRequest req = RestContext.request;
		Response doxisResponse = new Response();
		try {
			DoxisContract info =	(DoxisContract) System.JSON.deserialize(req.requestBody.toString(), DoxisContract.class);
			Contract contract = new Contract();
			contract.Doxis_Request__c = req.requestBody.toString();
			List<Account> l_accounts = [SELECT ID FROM Account WHERE NavisionId__c IN : info.md_navisionId];
			List<RecordType> l_recrodTypes = [SELECT ID FROM RecordType WHERE DeveloperName = 'MSA'];
			if (l_accounts.size() > 0) {
				contract.AccountId = l_accounts[0].Id;
			}
			if (contract.AccountId == null) {
				contract.AccountId = Admin_Setting__c.getOrgDefaults().Doxis_Account_Id__c;
			}
			contract.Doxis_Document__c = info.md_weblink;
			contract.Doxis_Id__c = info.md_id;
			if (l_recrodTypes.size() > 0) {
	        	contract.RecordTypeId = l_recrodTypes[0].Id;
			}
	        if (info.ci_invoiceAddress != null) {
	        	contract.BillingCity = info.ci_invoiceAddress.city;
		        contract.BillingCountryCode = info.ci_invoiceAddress.countryCode; 
		        contract.BillingPostalCode = info.ci_invoiceAddress.postalCode;
		        contract.BillingStateCode = info.ci_invoiceAddress.stateCode;
		        contract.BillingStreet = info.ci_invoiceAddress.street;
	        }
	        
	        if (info.bi_shippingAddress != null) {
	        	contract.ShippingCity = info.bi_shippingAddress.city;
		        contract.ShippingCountryCode = info.bi_shippingAddress.countryCode;
		        contract.ShippingPostalCode = info.bi_shippingAddress.postalCode;
		        contract.ShippingStateCode = info.bi_shippingAddress.stateCode;
		        contract.ShippingStreet = info.bi_shippingAddress.street;
	        }
	        
	        contract.Company_registration_number__c = info.ci_company_registration_number;
	        contract.VAT_number__c = info.ci_vat_number;
    		insert contract;
    		doxisResponse.contractId = contract.Id;
    		doxisResponse.status = 'Success';
			
		}
		catch (exception ex){
    		doxisResponse.status = 'Failed';
    		doxisResponse.errorMessage =  ex.getMessage();
		} 
		
		return JSON.serialize(doxisResponse);
	}
	
	public class Response {
		public Id contractId;
		public String status;
		public String errorMessage;
	}
}