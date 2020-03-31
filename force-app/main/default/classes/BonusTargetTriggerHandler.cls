public class BonusTargetTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public BonusTargetTriggerHandler (boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnBeforeInsert(List<Bonus_Target__c> l_new) {
    /*
        Map<String, Id> m_NameToId = new Map<String, Id>();
        for (Bonus_Target__c bonus : l_new) {
            if (bonus.Employee__c != null) {
                m_NameToId.put(bonus.Employee__c, null);
            }
            if (bonus.SVP__c != null) {
                m_NameToId.put(bonus.SVP__c, null);
            }
            if(bonus.Manager__c != null) {
                m_NameToId.put(bonus.Manager__c, null);
            }
        }

        List<User> l_users = [SELECT Id, Name FROM User WHERE Name IN :m_NameToId.keySet()];

        for (User user : l_users) {
            m_NameToId.put(user.Name, user.Id);
        }

        for (Bonus_Target__c bonus : l_new) {
            if (bonus.Employee__c != null) {
                Id employeeId = m_NameToId.get(bonus.Employee__c);
                if (employeeId != null) {
                    bonus.Employee_user__c = employeeId;
                }
            }
            if (bonus.SVP__c != null) {
                Id svpId = m_NameToId.get(bonus.SVP__c);
                if (svpId != null) {
                    bonus.SVP_User__c = svpId;
                }
            }
            if(bonus.Manager__c != null) {
               Id managerId = m_NameToId.get(bonus.Manager__c);
                if (managerId != null) {
                    bonus.Manager_User__c = managerId;
                }
            }
        }
        */
    }

   
    
    public void OnBeforeUpdate(List<Bonus_Target__c> l_old,List<Bonus_Target__c> l_new, Map<Id, Bonus_Target__c> m_new, Map<Id, Bonus_Target__c> m_old ){
      /*  Map<String, Id> m_NameToId = new Map<String, Id>();
        for (Bonus_Target__c bonus : l_new) {
            if (bonus.Employee__c != null && bonus.Employee__c != m_old.get(bonus.Id).Employee__c) {
                m_NameToId.put(bonus.Employee__c, null);
            }
            if (bonus.SVP__c != null  && bonus.SVP__c != m_old.get(bonus.Id).SVP__c) {
                m_NameToId.put(bonus.SVP__c, null);
            }
            if(bonus.Manager__c != null  && bonus.Manager__c != m_old.get(bonus.Id).Manager__c) {
                m_NameToId.put(bonus.Manager__c, null);
            }
        }

        List<User> l_users = [SELECT Id, Name FROM User WHERE Name IN :m_NameToId.keySet()];

        for (User user : l_users) {
            m_NameToId.put(user.Name, user.Id);
        }

        for (Bonus_Target__c bonus : l_new) {
            if (bonus.Employee__c != null  && bonus.Employee__c != m_old.get(bonus.Id).Employee__c) {
                Id employeeId = m_NameToId.get(bonus.Employee__c);
                if (employeeId != null) {
                    bonus.Employee_user__c = employeeId;
                }
            }
            if (bonus.SVP__c != null  && bonus.SVP__c != m_old.get(bonus.Id).SVP__c) {
                Id svpId = m_NameToId.get(bonus.SVP__c);
                if (svpId != null) {
                    bonus.SVP_User__c = svpId;
                }
            }
            if(bonus.Manager__c != null  && bonus.Manager__c != m_old.get(bonus.Id).Manager__c) {
               Id managerId = m_NameToId.get(bonus.Manager__c);
                if (managerId != null) {
                    bonus.Manager_User__c = managerId;
                }
            }
        }*/
    }
    public void OnAfterUpdate(List<Bonus_Target__c> l_old,List<Bonus_Target__c> l_new, Map<Id, Bonus_Target__c> m_new, Map<Id, Bonus_Target__c> m_old ){
        Set<Id> s_readWrite = new Set<Id>();
        Set<Id> s_read = new Set<Id>();
        Map<Id, User> m_users = new Map<Id, User>([SELECT ID, isActive FROM USER WHERE isActive = true]);
        List<Bonus_Target__Share> l_Share = new List<Bonus_Target__Share>();
        for(Bonus_Target__c target : l_new) {
            if ((target.Stage__c != m_old.get(target.Id).Stage__c ) 
            || (target.SVP_User__c != m_old.get(target.Id).SVP_User__c ) 
            ||(target.Manager_User__c != m_old.get(target.Id).Manager_User__c ) 
            ||(target.Employee_user__c != m_old.get(target.Id).Employee_user__c ) ) {
                Bonus_Target__Share tempRec = new Bonus_Target__Share();
                tempRec.ParentId = target.Id;
                tempRec.RowCause = Schema.Bonus_Target__Share.RowCause.Manual;

                if (target.Stage__c == 'SVP') {
                    tempRec.UserOrGroupId = target.SVP_User__c;
                    tempRec.AccessLevel = 'Edit';
                    
                }
                else if(target.Stage__c == 'Manager') {
                    tempRec.UserOrGroupId = target.Manager_User__c;
                    tempRec.AccessLevel = 'Read';
                }
                //else if(target.Stage__c == 'Employee') {
                    //tempRec.UserOrGroupId = target.Employee_user__c;
                    //tempRec.AccessLevel = 'Read';
                //}
                if (tempRec.UserOrGroupId != null && m_users.get(tempRec.UserOrGroupId) != null) {
                    l_Share.add(tempRec);
                }
            }
        }
        insert l_Share;
    }


    
    
}