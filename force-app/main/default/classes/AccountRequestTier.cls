/* 
 * Name   : AccountRequestTier 
 * Author       : Andrei Pruzan
 * Description   : Class Used to set info for Tier Update & credit check 
 * Maintenance History: 
 * 5/24/2017  - Created
 * 8/9/2017 - add logic in save action for credit check
*/
public with sharing class AccountRequestTier {
    public Account accountForEdit;
    public AccountRequestTier(ApexPages.StandardController con){
        accountForEdit = (Account) con.getRecord();
    }
    
    public PageReference SaveAction() {
        Map<String, Tier_Approvers__c> m_approvers = Tier_Approvers__c.getAll();
        User currentUser = [SELECT ID,Country_Group__c  FROM  User WHERE Id =: Userinfo.GetUserID()];
        String emails = null;
        String templateId = null;
        if (m_approvers.get(currentUser.Country_Group__c) != null){
            emails = m_approvers.get(currentUser.Country_Group__c).Emails__c;
            templateId = m_approvers.get(currentUser.Country_Group__c).Template__c;
        }
        else {
            emails = m_approvers.get('ALL').Emails__c;
            templateId = m_approvers.get('ALL').Template__c;
        }
        Admin_Setting__c setting = Admin_Setting__c.getOrgDefaults();
        if (ApexPages.currentPage().getUrl().containsIgnoreCase(Page.AccountCreditCheck.getUrl())) {
            emails = setting.Credit_Check_Emails__c;
            templateId = setting.Credit_Check_Email_template__c;
        }
        update accountForEdit;
        return new PageReference('/_ui/core/email/author/EmailAuthor?p3_lkid='+accountForEdit.Id+'&retURL=/'+accountForEdit.Id+'&template_id='+templateId+'&p24='+ emails);
    }
}