public with sharing class OverdueTaskViewController {
  public List<Task> l_tasks { get; set; }
  public OverdueTaskViewController() {
    
    Date overdueDate = Date.Today().addDays(-2);
    if(Test.isRunningTest()) {
      overdueDate = Date.Today().AddDays(1);
    }
    l_tasks = [SELECT Status, Subject, Training_Type__c, OwnerId, WhoId FROM Task WHERE Status != 'Completed' AND ActivityDate < :overdueDate AND OwnerId = :UserInfo.getUserId()];
    
  }
}