public class OpportunityItem_TriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public OpportunityItem_TriggerHandler (boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnAfterInsert(List<OpportunityLineItem> l_new) {
        Set<Id> s_ids = new Set<Id>();
        for(OpportunityLineItem item : l_new) {
            s_ids.add(item.OpportunityId);
        }
        updateOpportunity(s_ids);
    }

   
    
    public void OnAfterUpdate(List<OpportunityLineItem> l_old,List<OpportunityLineItem> l_new, Map<Id, OpportunityLineItem> m_new, Map<Id, OpportunityLineItem> m_old ){
        Set<Id> s_ids = new Set<Id>();
        for(OpportunityLineItem item : l_new) {
            if (item.OpportunityId != m_old.get(item.Id).OpportunityId) {
                s_ids.add(item.OpportunityId);
            }
        }
        updateOpportunity(s_ids);
    }
    
    
    public void OnAfterDelete(List<OpportunityLineItem> l_old){
        Set<Id> s_ids = new Set<Id>();
        for(OpportunityLineItem item : l_old) {
            s_ids.add(item.OpportunityId);
        }
        updateOpportunity(s_ids);
    }

    public static void updateOpportunity(Set<Id> s_ids){
        if (s_ids.size() > 0) {
            List<Opportunity> l_opp = [SELECT ID, Opportunity_Products__c,(SELECT Name, Product2.Name FROM OpportunityLineItems) FROM Opportunity WHERE Id IN: s_ids];
            for(Opportunity item : l_opp) {
                String product_name = null;
                List<String> l_names = new List<String>();
                for(OpportunityLineItem item_in : item.OpportunityLineItems) {
                    l_names.add(item_in.Product2.Name);
                }
                if (l_names.size() > 0) {
                    product_name = String.join(l_names, '; ');
                }
                item.Opportunity_Products__c = product_name;
            }
            update l_opp;
        }
    }
}