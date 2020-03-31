public class TaskTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public TaskTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }


    public void OnAfterUpdate(Task[] oldTasks, Task[] newTasks, Map<ID, Task> newMap, Map<Id, Task> oldMap){
        Map<Id, List<String>> m_contactToTraining = new Map<Id, List<String>>();
        Schema.sObjectType  contactObjectType = Schema.Contact.SObjectType;
        for(Task task : newTasks){
            if (task.Training_Type__c != null && task.WhoId != null && task.Status == 'Completed' && task.Status != oldMap.get(task.Id).Status && task.WhoId.getSobjectType() == contactObjectType) {
                    List<String> l_temp = new List<String>();
                        if (m_contactToTraining.containsKey(task.WhoId)) {
                                l_temp = m_contactToTraining.get(task.WhoId);
                        }
                        l_temp.add(task.Training_Type__c);
                        m_contactToTraining.put(task.WhoId,l_temp);
            }   
        }
        if (m_contactToTraining.size() > 0) {
                List<Contact> l_contacts = [SELECT Id, Trainings_Completed__c FROM Contact WHERE Id IN :m_contactToTraining.keySet()];
                for(Contact item : l_contacts) {
                        List<String> l_temp = m_contactToTraining.get(item.Id);
                        if (item.Trainings_Completed__c == null) {
                                item.Trainings_Completed__c = String.join(l_temp,';');
                        }
                        else {
                                item.Trainings_Completed__c = item.Trainings_Completed__c +';'+String.join(l_temp,';');
                        }
                }
                update l_contacts;
        }
        
        
    }

}