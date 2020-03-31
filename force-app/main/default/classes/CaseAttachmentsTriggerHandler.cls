public class CaseAttachmentsTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public CaseAttachmentsTriggerHandler(boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnAfterInsert(Attachment[] newAttachement) {
        List<Case> l_cases = [SELECT Id, Status FROM Case WHERE Id = :newAttachement[0].ParentId];
        if(l_cases.size() > 0){
            l_cases[0].Status = 'Signed and Start production';
            upsert l_cases[0];
        }
    }
}