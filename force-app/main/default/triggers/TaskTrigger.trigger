trigger TaskTrigger on Task (after update) {
  TaskTriggerHandler handler = new TaskTriggerHandler(Trigger.isExecuting, Trigger.size);

  if(Trigger.isUpdate && Trigger.isAfter){
    handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap, Trigger.oldMap);
  }
}