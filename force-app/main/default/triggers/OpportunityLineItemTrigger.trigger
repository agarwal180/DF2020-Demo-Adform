trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert, after insert, before update, after update, after delete) {
    
     OpportunityItem_TriggerHandler handler = new OpportunityItem_TriggerHandler(Trigger.isExecuting, Trigger.size);
     
    if(Trigger.isInsert && Trigger.isAfter){
        handler.OnAfterInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap, Trigger.oldMap);
    }  
    else if (Trigger.isDelete && Trigger.isAfter) {
        handler.OnAfterDelete(Trigger.old);
    }
}