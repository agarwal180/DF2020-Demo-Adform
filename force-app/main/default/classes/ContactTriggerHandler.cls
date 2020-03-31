public class ContactTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public ContactTriggerHandler (boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert(List<Contact> l_new) {
        Set<Id> s_accIds = new Set<Id>();
        Map<String, String> m_accounts = new Map<String, String>();
        for(Contact con : l_new){
            s_accIds.add(con.AccountId);
        }
        for(Account acc : [SELECT Id, Relationship_Type__c FROM Account WHERE Id In :s_accIds]){
            m_accounts.put(acc.Id, acc.Relationship_Type__c);
        }
        for(Contact con : l_new){
            String typeAcc = m_accounts.get(con.AccountId);
            if (typeAcc != null) {
                if (typeAcc == 'Brand/Advertiser') {
                    con.Company_Type_custom__c = 'Advertiser';
                }
                else {
                    con.Company_Type_custom__c = typeAcc;
                    con.Account_Type__c = typeAcc;
                }
            }
        }
    }

    public void OnAfterInsert(List<Contact> l_new) {
        Set<Id> s_accids = new Set<Id>(); 
        for(Contact item : l_new) {
            if (item.AccountId != null) {
                s_accids.add(item.AccountId);
            }
        }
        updateAccounts(s_accids);
    }

    public void OnBeforeUpdate(List<Contact> l_old,List<Contact> l_new, Map<Id, Contact> m_new, Map<Id, Contact> m_old) {
        Set<Id> s_accIds = new Set<Id>();
        Map<String, String> m_accounts = new Map<String, String>();
        for(Contact con : l_new){
            s_accIds.add(con.AccountId);
        }
        for(Account acc : [SELECT Id, Relationship_Type__c FROM Account WHERE Id In :s_accIds]){
            m_accounts.put(acc.Id, acc.Relationship_Type__c);
        }
        for(Contact con : l_new){
            String typeAcc = m_accounts.get(con.AccountId);
            if (typeAcc != null) {
                if (typeAcc == 'Brand/Advertiser') {
                    con.Company_Type_custom__c = 'Advertiser';
                }
                else {
                    con.Company_Type_custom__c = typeAcc;
                    con.Account_Type__c = typeAcc;
                }
            }
        }
    }
    
    public void OnAfterUpdate(List<Contact> l_old,List<Contact> l_new, Map<Id, Contact> m_new, Map<Id, Contact> m_old){
       Set<Id> s_accids = new Set<Id>(); 
        for(Contact item : l_new) {
            if (item.AccountId != null) {
                s_accids.add(item.AccountId);
            }
        }
        updateAccounts(s_accids);
    }
    
    
    public void OnAfterDelete(List<Contact> l_old){
        Set<Id> s_accids = new Set<Id>(); 
        for(Contact item : l_old) {
            if (item.AccountId != null) {
                s_accids.add(item.AccountId);
            }
        }
        updateAccounts(s_accids);
    }

    public static void updateAccounts(Set<Id> s_ids) {
        List<Account> l_accounts = new List<Account>();
        for(Id sId : s_ids) {
            l_accounts.add(new Account(Id = sId));
        }
        update l_accounts;
    }
}