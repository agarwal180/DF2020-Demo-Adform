trigger InvoiceTemplateTrigger on Invoice_Template__c (after insert, after update, after delete) {
    InvoiceTemplateTriggerHandler handler = new InvoiceTemplateTriggerHandler(Trigger.isExecuting, Trigger.size);
    if(Trigger.isInsert && Trigger.isAfter){
        handler.OnAfterInsert(Trigger.new);
    }   
    else if(Trigger.isUpdate && Trigger.isAfter){
        handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap, Trigger.oldMap);
    }   
    else if(Trigger.isDelete && Trigger.isAfter){
        handler.OnAfterDelete(Trigger.old);
    }   
    
}