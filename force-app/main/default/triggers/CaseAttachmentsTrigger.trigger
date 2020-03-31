trigger CaseAttachmentsTrigger on Attachment (after insert) {
    CaseAttachmentsTriggerHandler handler = new CaseAttachmentsTriggerHandler(Trigger.isExecuting, Trigger.size);
    if(Trigger.isInsert && Trigger.isAfter){
        handler.OnAfterInsert(Trigger.new);
    }
}