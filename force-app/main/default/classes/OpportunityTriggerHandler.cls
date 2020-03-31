public class OpportunityTriggerHandler {

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public OpportunityTriggerHandler(boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(List<Opportunity> l_new) {
        for(Opportunity opp : l_new){
            opp.Display_Popup__c = true;
        }
    }
    
    public void OnBeforeUpdate(List<Opportunity> l_old, List<Opportunity> l_new, Map<Id, Opportunity> m_new, Map<Id, Opportunity> m_old ){
        String oldStageName;
        for(Opportunity oldOpp : l_old){
            oldStageName = oldOpp.StageName;
        }
        String oppId;
        for(Opportunity opp : l_new){
            if(oldStageName != null && opp.StageName != null && oldStageName != opp.StageName){
                opp.Display_Popup__c = true;
            }
        }
    }
}