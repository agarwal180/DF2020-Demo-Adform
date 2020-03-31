public class TriggerHandlerGeneral {

    private static final List<Triggers_Settings__c> TRIGGERS_SETTINGS = Triggers_Settings__c.getAll().values();

    public static Boolean isTriggerRun(String triggerName) {
        for (Triggers_Settings__c setting : TRIGGERS_SETTINGS) {
            if ((setting.Trigger_name__c.equals(triggerName) || setting.Trigger_name__c.equals('All'))
             && (setting.User_Id__c.equals(UserInfo.getUserId()) || setting.User_Id__c.equals('All'))
             && !setting.Is_Active__c) {
                return false;
            }
        }
        return true;
    }
}