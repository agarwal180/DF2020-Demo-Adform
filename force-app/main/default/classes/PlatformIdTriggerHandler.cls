public class PlatformIdTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public PlatformIdTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnAfterInsert(List<Platform_ID__c> l_new) {
        Set<Id> s_ids = new Set<Id>();
        for(Platform_ID__c item : l_new) {
            if (item.Account__c != null) {
                s_ids.add(item.Account__c);
            }
        }
        Utilities.updateAccounts(s_ids);
    }

   
    
    public void OnAfterUpdate(List<Platform_ID__c> l_old,List<Platform_ID__c> l_new, Map<Id, Platform_ID__c> m_new, Map<Id, Platform_ID__c> m_old ){
        Set<Id> s_ids = new Set<Id>();
        for(Platform_ID__c item : l_new) {
            if (item.Account__c != null) {
                s_ids.add(item.Account__c);
            }
        }
        Utilities.updateAccounts(s_ids);
    }
    
    
    public void OnAfterDelete(List<Platform_ID__c> l_old){
        Set<Id> s_ids = new Set<Id>();
        for(Platform_ID__c item : l_old) {
            if (item.Account__c != null) {
                s_ids.add(item.Account__c);
            }
        }
        Utilities.updateAccounts(s_ids);
    }


}