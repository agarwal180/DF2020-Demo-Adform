/* 
* Name    : EditLegalInfoRequestController 
* Author  : Shreshtha Dashora
* Description   : Class used for Fetching email template id in EditLegalIfo Request Quick action in lightning
* Maintenance History: 16/03/2020
*/  
public with sharing class EditLegalInfoRequestController {
	@AuraEnabled
    public static String getTemplateID() {
      EmailTemplate et=[SELECT Id,Body,Subject,Name FROM EmailTemplate WHERE Name = 'Edit Legal Info'];
      return et.Id;
    }
}