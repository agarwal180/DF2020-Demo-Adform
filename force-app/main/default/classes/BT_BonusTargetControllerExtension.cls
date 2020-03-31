public without sharing class BT_BonusTargetControllerExtension {

    private ApexPages.StandardSetController stdController;
    private String success;
    private String error;
    private String userType;
    private Boolean isSVP = false;
    private Boolean isManager = false;
    private Boolean IsMainUser = false;
    public Boolean isError { get; set; }
    public String ErrorMessage { get; set; }
    public String message { get; set; }
    public List<Bonus_Target__c> l_targers; 

    public BT_BonusTargetControllerExtension(ApexPages.StandardSetController controller) {
        isError = false;
        this.stdController = controller;
        controller.addFields(new List<String>{
                'SVP_User__c', 'Stage__c', 'Employee_user__c', 'Manager_User__c', 'Status__c'
        });
        controller.setPageSize(controller.getResultSize());
        if (ApexPages.currentPage().getUrl().containsIgnoreCase(Page.BT_NotifySVPUsers.getUrl())) {
            message = 'Please confirm if you want to notify SVP';
            userType = Constants.USER_TYPE_MAIN;
        }
        else if (ApexPages.currentPage().getUrl().containsIgnoreCase(Page.BT_NotifyEmployeeUsers.getUrl())) {
            message = 'Please confirm if you want to notify Employee';
            userType = Constants.USER_TYPE_MANAGER;
        }
        l_targers = this.stdController.getSelected();
        if (l_targers.size() == 0) {
            l_targers = this.stdController.getRecords();
        }
        if (ApexPages.currentPage().getUrl().containsIgnoreCase(Page.BT_NotifySVPUsers.getUrl()) || ApexPages.currentPage().getUrl().containsIgnoreCase(Page.BT_NotifyEmployeeUsers.getUrl())) {
            ErrorMessage = validateUsers(l_targers, userType);
            if (ErrorMessage != null)  {
                    isError = true;
            }
        }
    }

    public String validateUsers (List<Bonus_Target__c> l_targets, String type) {
        String tempError = null;
        for(Bonus_Target__c target : l_targets) {
            if(type == Constants.USER_TYPE_SVP) {
                if (target.Stage__c != 'SVP') {
                    tempError = 'All records should be in stage SVP';
                }
            }
            else {
                if (target.Stage__c != 'Draft' &&( target.Employee_user__c == null ||  target.SVP_User__c == null)) {
                    tempError = 'All records should be in stage Draft and Manager, Employee & SVP users should be filled in';
                }
            }
            if (target.Status__c == 'Inactive') {
                tempError = 'All records should be in Status Active';
                break;
            }
        }
        return tempError;
    }
    
    public PageReference DeactivateAllRecords() {
        List<Bonus_Target__c> l_targets = [SELECT Id, Status__c FROM Bonus_Target__c WHERE Status__c = 'Active'];
        for(Bonus_Target__c target : l_targets) {
            target.Status__c = 'Inactive';
        }
        update l_targets;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Bonus targets deactivated.'));
        return null;
    }
    public Id defineEmployee(Id employeeId, Map<Id,User> m_employees, Map<Id,User> m_allusers) {
        Id UserId = null;
        for(Id item : m_employees.keySet()) {
            if (employeeId == item) {
                UserId =  item;
                break;
            }
        }
        if (UserId == null) {
            for(Id item : m_employees.keySet()) {
            User tempUser1 = m_allusers.get(item);
            for(User u1 : tempUser1.ManagedUsers) {
                if (employeeId == u1.Id) {
                    return item;
                }
                else {
                    User tempUser2 = m_allusers.get(u1.id);
                    for(User u2 : tempUser2.ManagedUsers) {
                        if (employeeId == u2.Id) {
                            return item;
                        }else {
                            User tempUser3 = m_allusers.get(u2.id);
                            for(User u3 : tempUser3.ManagedUsers) {
                                if (employeeId == u3.Id) {
                                    return item;
                                }else {
                                    User tempUser4 = m_allusers.get(u3.id);
                                    for(User u4 : tempUser4.ManagedUsers) {
                                        if (employeeId == u4.Id) {
                                            return item;
                                        }else {
                                            User tempUser5 = m_allusers.get(u4.id);
                                            for(User u5 : tempUser5.ManagedUsers) {
                                                if (employeeId == u5.Id) {
                                                    return item;
                                                }else {
                                                    User tempUser6 = m_allusers.get(u5.id);
                                                    for(User u6 : tempUser6.ManagedUsers) {
                                                        if (employeeId == u6.Id) {
                                                            return item;
                                                        }else {
                                                            User tempUser7 = m_allusers.get(u6.id);
                                                            for(User u7 : tempUser7.ManagedUsers) {
                                                                if (employeeId == u7.Id) {
                                                                    return item;
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            }
        }
        return UserId;
    }

    public PageReference notifyUsers(){

        Set<Id> s_employeeIds = new Set<Id>();
        for(Bonus_Target__c target : l_targers) {
            //s_employeeIds.add(target.Employee_user__c);
        }
        Map<Id,User> m_employees = new Map<Id,User>([Select Id from User where ManagerId =: UserInfo.getUserId() AND isActive = true]);
        Map<Id,User> m_allusers = new Map<Id,User>([Select Id, (Select id from ManagedUsers WHERE isActive = true) from user WHERE isActive = true]);
        String Stage = 'SVP';
        if(userType == Constants.USER_TYPE_SVP) {
            Stage = 'Manager';
        }
        else if(userType == Constants.USER_TYPE_MANAGER){
            Stage = 'Manager';
        }
        Set<Id> s_userIds = new Set<Id>();
        Set<Id> s_employee = new Set<Id>();
        for(Bonus_Target__c target : l_targers) {
            
            if(userType == Constants.USER_TYPE_SVP) {
                s_userIds.add(target.Manager_User__c);
                //target.Manager_User__c = target.Manager_User__c;
            }
            else if (userType == Constants.USER_TYPE_MANAGER) {
                Stage = 'Manager';
                Id userId = defineEmployee(target.Employee_user__c, m_employees, m_allusers);
                system.debug('========='+userId);
                target.Manager_User__c = userId;
                if(userId != null) {
                    if (userId == target.Employee_user__c) {
                        Stage = 'Employee';
                        target.OwnerId = target.Employee_user__c;
                        s_employee.add(userId);
                    }
                    else {
                        s_userIds.add(target.Manager_User__c);
                    }
                }
            }
            else {
                s_userIds.add(target.SVP_User__c);
            }
            target.Stage__c = Stage;
        }
        update l_targers;
        List<Messaging.MassEmailMessage> l_messages = new List<Messaging.MassEmailMessage>();
        if (s_userIds.size() > 0) {
            Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
            mail.setTargetObjectIds(new List<Id>(s_userIds));
            EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE developerName = 'Bonus_targets_notification' LIMIT 1];
            mail.setTemplateId(template.Id);
            mail.setSaveAsActivity(false);
            l_messages.add(mail);
        }
        if (s_employee.size() > 0) {
            Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
            mail.setTargetObjectIds(new List<Id>(s_employee));
            EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE developerName = 'Bonus_targets_notification_Employee' LIMIT 1];
            mail.setTemplateId(template.Id);
            mail.setSaveAsActivity(false);
            l_messages.add(mail);
        }
        

        List<Messaging.SendEmailResult> results = Messaging.sendEmail(l_messages);
        
        if (results.get(0).success) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Notifications sent successfully'));
            return null;
        }
        else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Notifications were not sent due to some error'));
            return null;
        }
        return null;
    }


    private Map<Id, List<Bonus_Target__c>> getSvpBonusMap() {
        /*Map<Id, List<Bonus_Target__c>> m_SvpBonus = new Map<Id, List<Bonus_Target__c>>();
        Set<Id> users = new Set<Id>();

        for (Bonus_Target__c bonus_target : getSelected()) {
            if (bonus_target.SVP_User__c != null && String.isNotBlank(bonus_target.SVP_User__c)) {
                users.add(bonus_target.SVP_User__c);
            }
        }

        for (Id userId : users) {
            List<Bonus_Target__c> l_bonusTargetsForSVP = new List<Bonus_Target__c>();
            for (Bonus_Target__c bonus_target : getSelected()) {
                if (bonus_target.SVP_User__c == userId) {
                    l_bonusTargetsForSVP.add(bonus_target);
                }

                m_SvpBonus.put(userId, l_bonusTargetsForSVP);
            }
        }
    */
        return null;
    }

    public void sendEmailToSvp() {
        Map<Id, List<Bonus_Target__c>> m_SvpBonus = getSvpBonusMap();
        if (!m_SvpBonus.isEmpty()) {
            Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
            mail.setTargetObjectIds(new List<Id>(m_SvpBonus.keySet()));
            EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE Name = 'Bonus targets notification' LIMIT 1];
            mail.setTemplateId(template.Id);
            mail.setSaveAsActivity(false);
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.MassEmailMessage[]{
                    mail
            });

            if (results.get(0).success) {
                this.success = 'Notifications sent successfully';
            } else {
                this.error = 'Notifications were not sent due to some error';
            }
        } else {
            this.error = 'SVP email address list is empty';
        }
    }

    public PageReference cancel() {
        return stdController.cancel();
    }

    public String getSuccess() {
        return success;
    }

    public String getError() {
        return error;
    }

}