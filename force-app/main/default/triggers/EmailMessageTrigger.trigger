trigger EmailMessageTrigger on EmailMessage (before insert) 
{
    EmailMessageTriggerHandler handler = new EmailMessageTriggerHandler(Trigger.isExecuting, Trigger.size);
    if(Trigger.isInsert && Trigger.isBefore) {   
            handler.OnBeforeInsert(Trigger.new);
    }
}