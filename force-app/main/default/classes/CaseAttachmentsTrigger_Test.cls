@isTest(SeeAllData = false)
public class CaseAttachmentsTrigger_Test{
    @testSetup static void caseAttachmentsTriggerTestData(){
        Case c = new Case();
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Creative Production - Signed Agreement'];
        c.RecordTypeId = rt.Id;
        c.Status = 'Start Production';
        c.I_confirm_that_Legal_document_is_signed__c = true;
        c.Subject = 'testCasetest';
        c.RTB__c = 'Yes';
        c.RTB_Limit__c = 2000.00;
        insert c;
        
        Attachment att = new Attachment();
        att.Name = 'new attachment';
        Blob bodyBlob = Blob.valueOf('test attachment body');
        att.body = bodyBlob;
        att.parentId = c.Id;
        att.ContentType = 'application/msword';
        att.IsPrivate = false;
        att.Description = 'test';
        insert att;

    }
    
    static testmethod void getChangedCaseStatus(){
        Case c = [SELECT Id, Status FROM Case WHERE Subject = 'testCasetest'];
        System.assert(c.Status == 'Signed and Start production');
    }
}