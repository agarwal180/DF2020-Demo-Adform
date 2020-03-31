/* 
* Name    : ContractController 
* Author  : Subham Agarwal
* Description   : Class used for lighting components related to  Contract object
* Maintenance History: 13/03/2020

*/  
public with sharing class ContractController {
    
    /* 
@Name      - getContractStatus
@Parameter    - recId - Contract Object id 
@Return Type  - String - if all ok return Success if not return error message 
@Description  -  this method used to get Contract Status.
*/
    @AuraEnabled
    public static String getApprovalStatus(Id recId) {
        Contract contr =  [SELECT Id,Approval_Status__c FROM Contract WHERE Id= :recId];
        if (contr.Approval_Status__c != 'Approved') {
            return 'Contract not approved';
        }else{
            return 'SUCCESS';
        }
    }
    
    @AuraEnabled
    public static String getContractStatus(Id recId) {
        Contract contr =  [SELECT Id,Status FROM Contract WHERE Id= :recId];
        if (contr.Status != 'Activated') {
            return 'You cannot Create pricing variation for not Activated contract';
        }else{
            return 'SUCCESS';
        }
    }
    @AuraEnabled
    public static String getStatus(Id recId) {
        Id profileId= userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('ProfileName'+profileName);
        Contract contr =  [SELECT Id,Status,Approval_Status__c FROM Contract WHERE Id= :recId];
        if (contr.Approval_Status__c == 'Need approval') {
            return 'You cannot Edit prices when contract in Need approval status';
        }
        else if (contr.Status == 'Activated' && profileName != 'System Administrator') {
            return 'You cannot Edit prices when contract Activated';
        }
        return 'SUCCESS';
    }
    
    
}