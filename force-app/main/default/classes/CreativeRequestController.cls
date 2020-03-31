/*
    * Name        : CreativeRequestController
    * Author        : Greta Alsyte
    * Maintenance History:
    * 2018-07-05
*/
public with sharing class CreativeRequestController{
    Public Case caseForEdit;
    
    Public CreativeRequestController(ApexPages.StandardController con){
        caseForEdit = (Case) con.getRecord();
    }

    public PageReference saveNew() {
        EmailTemplate et = [select id from EmailTemplate where developername= 'Creative_Production_Form'];
        update caseForEdit;
        return new PageReference('/_ui/core/email/author/EmailAuthor?p3_lkid='+CaseForEdit.Id+'&retURL=/'+caseForEdit.Id+'&template_id='+et.id+'+&p24=production@adform.com');
    }
}