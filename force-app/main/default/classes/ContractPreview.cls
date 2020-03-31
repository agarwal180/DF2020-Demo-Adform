public with sharing class ContractPreview{
	public String contractId;
	public Contract tempContract;
	public ContractPreview(ApexPages.StandardController con){
		contractId = con.getId();
		tempContract = [SELECT ID, Opportunity__c, Client_with_MSA_PMSA__c FROM Contract WHERE Id =: contractId];
	}

	public PageReference SendInfoToClient(){
		Contract tempContract = [SELECT ID, Client_s_contact_name__c,CurrencyIsoCode,Opportunity__c, Account.Name, Client_s_contact_name__r.Name FROM Contract WHERE Id=:contractId];
		Case tempcase = createNewCase(contractId,Constants.CASE_ORIGIN_PDF, tempContract);
		Id docId = createDocument(contractId,tempcase.Id,tempContract);
		String CaseId = Utilities.make15SymbolsId(tempcase.Id);
		Id templateId = getIdFromSetting('PDF_Template');
		String url = prepareURL(CaseId,contractId, docId, tempContract, templateId);
		return new Pagereference(url);
	}
	
	public PageReference SendMSAOrPMSA(){
		tempContract = [SELECT ID, Opportunity__c, Client_with_MSA_PMSA__c FROM Contract WHERE Id =: contractId];
		if(tempContract.Client_with_MSA_PMSA__c) {
			Contract tempContract = [SELECT ID, Client_s_contact_name__c,CurrencyIsoCode,Opportunity__c, Account.Name, Client_s_contact_name__r.Name FROM Contract WHERE Id=:contractId];
			Case tempcase = createNewCase(contractId,Constants.CASE_ORIGIN_EMAIL, tempContract);
			String CaseId = Utilities.make15SymbolsId(tempcase.Id);
			Id templateId = getIdFromSetting('MSAorPMSA_Template');
			String url = prepareURL(CaseId,contractId, null, tempContract, templateId);
			PageReference newPage =  new pageReference(url);
			newPage.setRedirect(true);
			return newPage;
		}
		return null;
	}
	
	public pageReference SendInfoTobilling() {
		Contract tempContract = [SELECT ID, Client_s_contact_name__c,CurrencyIsoCode,Opportunity__c, Account.Name, Client_s_contact_name__r.Name FROM Contract WHERE Id=:contractId];
		tempContract.Client_s_contact_name__c = getIdFromSetting('BillingContact');
		Case tempcase = createNewCase(contractId,Constants.CASE_ORIGIN_RIGHT_SIGNATURE, tempContract);
		Id docId = createDocument(contractId,tempcase.Id,tempContract);
		String CaseId = Utilities.make15SymbolsId(tempcase.Id);
		Id templateId = getIdFromSetting('Signature_Template');
		String url = prepareURL(CaseId,contractId, docId, tempContract, templateId);
		return new Pagereference(url);
	}
	
	public Id createDocument(Id contrId, Id caseId, Contract tempContract){
		PageReference pdf = Page.IOContract;
		pdf.getParameters().put('Id',contrId);
		pdf.setRedirect(true);
		Blob b;
		if(!Test.isRunningTest()) {
			 b = pdf.getContent();
		}
		String tmpDocName = tempContract.Account.Name+Constants.DOCUMENT_NAME;
		Document document = new Document();
		document.AuthorId = UserInfo.getUserId();
		document.FolderId = UserInfo.getUserId(); // put it in running user's folder
		document.IsPublic = true;
		document.Keywords = caseId;
		document.Name = tmpDocName.replaceAll(' ', '_');
		document.ContentType = 'application/pdf';
		document.Body = b;
		insert document; 
		return document.Id;
	}
	public Case createNewCase(Id contrId, String caseOrigin, Contract tempContract) {
		List<RecordType> recordTypes = [SELECT ID FROM RecordType WHERE DeveloperName = :Constants.ORDER_RECORD_TYPE AND SobjectType = 'Case'];
		Case tempcase = new Case();
		tempcase.Contract__c = contrId;
		if(recordTypes.size() > 0) {
			tempcase.RecordTypeId = recordTypes[0].Id;
		}
		if(tempContract.Client_s_contact_name__c != null && Test.isRunningTest() == false) {
			tempcase.ContactId = tempContract.Client_s_contact_name__c;
		}
		tempcase.Subject = Constants.CASE_TEMP_SUBJECT;
		tempcase.CurrencyIsoCode = tempContract.CurrencyIsoCode;
		tempcase.Origin = caseOrigin;
		tempcase.Opportunity__c = tempContract.Opportunity__c;
		insert tempcase;
		return tempcase;
	}
	public String prepareURL(String caseId, Id contrId, Id docId, Contract tempContract, Id templateId) {
		Id OrgWideId = getIdFromSetting('ORG_WIDE_EMAIL_ORDER');
		List<OrgWideEmailAddress> orgEmails = [SELECT Address,DisplayName,Id FROM OrgWideEmailAddress WHERE Id =: OrgWideId];
		OrgWideEmailAddress tempEmail = null;
		if(orgEmails.size() > 0) {
			tempEmail = orgEmails[0];
		} 
		String url = '/_ui/core/email/author/EmailAuthor?';
		if(caseId != null) {
			url+='p3_lkid='+caseId;
		}
		if(contrId != null) {
			url+='&retURL=/'+contrId;
		}
		if(docId != null) {
			url+='&doc_id='+docId;
		}
		if(tempContract != null) {
			url+='&p2_lkid='+tempContract.Client_s_contact_name__c;
		}
		if(templateId != null) {
			url+='&template_id='+templateId;
		}
		if(tempEmail != null) {
			url+='&p26='+tempEmail.Id+':'+tempEmail.Address+':'+tempEmail.DisplayName;
		}
		
		url+='&rtype=003';	
		return url;
	}
	public Id getIdFromSetting(String recordName) {
		Field_Setting__c record = Field_Setting__c.getValues(recordName);
		Id recordId = null;
		if(record != null) {
			recordId = record.Field_Id__c;
		}
		if(Test.isRunningTest()) {
			recordId = userInfo.getUserId();
		}
		return recordId;
	}
}