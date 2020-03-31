/* 
  * Name    : CaseController 
  * Author  : Andrei Pruzan
  * Description   : Class used for lighting compoentns related to  Case object
  * Maintenance History: 1/06/2018
  
*/  
public with sharing class CaseController {

    /* 
        @Name      - getMessage
        @Parameter    - recId - Case Object id 
        @Return Type  - String - if all ok return Success if not return error message 
        @Description  -  this method used defin ef redirect action can be implemented or not. Validate if attechmnet exist on case object.
    */
    @AuraEnabled
    public static String getMessage(Id recId) {
        Case case_rec =  [SELECT Id,Status, (SELECT ID FROM AttachedContentDocuments LIMIT 1) FROM Case WHERE Id= :recId];
        if (case_rec.Status != 'Signed and start production' && case_rec.Status != 'Start Production') {
            return 'Form can not be submited if there is legal document signed. Please make sure legal document is in the system';
        }
        else if (case_rec.Status != 'Start Production' && case_rec.AttachedContentDocuments.size() == 0) {
        System.debug(case_rec.AttachedContentDocuments);
            return 'Please provide signed Creative Production Order';
        }
        return 'SUCCESS';

    }

}