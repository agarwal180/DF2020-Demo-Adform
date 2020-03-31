/* Fill the "Parent Account" field on converted-Lead accounts */
trigger SetAccountField on Lead (after update) {
    if(Trigger.isUpdate && Trigger.isAfter) {
        Set<Id> s_accountIds = new Set<Id>();
        Set<Id> s_opportunityIds = new Set<Id>();
        for (Lead l: Trigger.new) {
           if (l.isConverted && Trigger.oldMap.get(l.id).isConverted == false) {
               s_accountIds.add(l.ConvertedAccountId);
               if(l.ConvertedOpportunityId != null){
                   s_opportunityIds.add(l.ConvertedOpportunityId);
               }
           }
        }
        if (s_accountIds.size() > 0) {
           Map<Id, Account> m_accounts = new Map<Id, Account>([SELECT Id, ParentId FROM Account WHERE Id IN :s_accountIds]);
           Map<Id, Opportunity> m_opportunities = new Map<Id, Opportunity>([SELECT Id, Display_Popup__c FROM Opportunity WHERE Id IN : s_opportunityIds]);
           List<Account> l_accounts = new List<Account>();
           List<Opportunity> l_opportunities = new List<Opportunity>();
           for (Lead l: Trigger.new) {
                Account tempAccount = m_accounts.get(l.ConvertedAccountId);
                Opportunity tempOpportunity = m_opportunities.get(l.ConvertedOpportunityId);
                if(tempAccount != null && tempAccount.ParentId != l.Parent_Account__c && tempAccount.Id != l.Parent_Account__c) {
                    tempAccount.ParentId = l.Parent_Account__c;
                    l_accounts.add(tempAccount);
                }
                if(tempOpportunity != null){
                    tempOpportunity.Display_Popup__c = true;
                    l_opportunities.add(tempOpportunity);
                }
           }
           if (l_accounts.size() > 0) {
               update l_accounts;
           }
           if(l_opportunities.size() > 0){
               update l_opportunities;
           }
          
       }
    }
}