public with sharing class BonusTarget {
    public List<Bonus_Target__c> l_target { get; set; }
    public User currentUser { get; set ;}
    
    public BonusTarget() {
        l_target = [SELECT April__c,August__c,Bad_debts__c,Bonus_Currency__c,BONUS_OTE_in_l_c__c,Bonus_split__c,Comment__c,Country__c,CreatedById,
                    CreatedDate,CurrencyIsoCode,Current_Year_Target__c,Customer_Type__c,December__c,Employee_user__c,Employee__c,February__c,
                    Guaranteed_Period_End__c,Guaranteed_Period_Start__c,Id,IsDeleted,January__c,July__c,June__c,LastModifiedById,LastModifiedDate,
                    LY_April__c,LY_August__c,LY_December__c,LY_February__c,LY_January__c,LY_July__c,LY_June__c,
                    LY_March__c,LY_May__c,LY_November__c,LY_October__c,LY_September__c,Manager_User__c,Manager__c,March__c,May__c,
                    Name,November__c,October__c,Office__c,OwnerId,Previous_Year_Actual__c,Product__c,September__c,Stage__c,Status__c,
                    SVP_User__c,SVP__c,SystemModstamp,Target_currency__c,Target_ID__c,Target__c,Year_for_target__c,YoY__c,
                    LY_Actual__c, Target_Q1__c, Target_Q2__c, Target_Q3__c, Target_Q4__c FROM Bonus_Target__c WHERE Stage__c = 'Employee' AND Employee_user__c =: UserInfo.getUserId() AND Status__c = 'Active'];
        
        currentUser = [SELECT ID, FirstName, Lastname, ManagerId FROM User WHERE  ID =:UserInfo.getUserId()];
       
    }

    
}