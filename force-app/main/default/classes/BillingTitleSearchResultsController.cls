/*
    * Name        : BillingTitleSearchResultsController
    * Author        : Dmitrij Marcinkevic
    * Description   : Class displays all Accounts with such Billing Title
    * Maintenance History:
    * 2018-06-27
*/
public with sharing class BillingTitleSearchResultsController {
    public List<Account> l_accounts { get; set; }
    public String searchValue { get; set; }
    public BillingTitleSearchResultsController(){
        searchValue = ApexPages.currentPage().getParameters().get('sbstr');
        l_accounts = getAccounts(searchValue);
    }

    private List<Account> getAccounts(String searchValue){
        List<Schema.FieldSetMember> l_fields = SObjectType.Account.FieldSets.foundAccounts.getFields();
        String query = 'SELECT ';
        for(Schema.FieldSetMember field : l_fields){
            query += field.getFieldPath() + ', ';
        }
        query = query.trim();
        query = query.substring(0, query.length() - 1);
        query += ' FROM Account WHERE Id IN (SELECT Account__c FROM Platform_ID__c WHERE Billing_Title__c LIKE \'%' + searchValue + '%\' )';
        List<Account> l_accounts = Database.query(query);
        return l_accounts;
    }
    
    public PageReference searchAction() {
        l_accounts = getAccounts(searchValue);
        return null;
    }
    
    public PageReference homeRedirect() {
        return new PageReference('/home/home.jsp');
    }
}