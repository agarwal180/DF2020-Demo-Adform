global with sharing class MigrationServicesController {
    public Contract contract { get; set; }
    public List<SelectOption> emails { get; set; }
    public List<SelectOption> contacts { get; set; }
    public List<SelectOption> effectivedays { get; set; }
    public String contactToemailJson { get; set; }
    public String recordType { get; set; }
    public String opportunityId { get; set; }
    public List<SelectOption> migrationModels { get; set; }
    public List<SelectOption> packageSizes { get; set; }
    public Id contractId;

    public MigrationServicesController(ApexPages.StandardController con){
        this.contract = (Contract) con.getRecord();
        RecordType rt = [SELECT Id FROM Recordtype WHERE developerName = 'Migration_Services_Addendum'];
        Id oppId = ApexPages.currentPage().getParameters().get('oppId');
        if(oppId == null && this.contract.Id != null){
            oppId = [SELECT Opportunity__c FROM Contract WHERE Id =:this.contract.Id].Opportunity__c;
        }
        this.contractId = contract.Id;
        contacts = new List<SelectOption>();
        emails = new List<SelectOption>();
        Opportunity oppRecord = [SELECT Id, AccountId FROM Opportunity WHERE Id = :oppId];
        migrationModels = getMigrationModelValues();
        packageSizes = getPackageSizeValues();
        effectivedays =  new List<SelectOption>{new SelectOption('', '--Please select Date--')};

        if (this.contract.Id == null){
            this.contract.Opportunity__c = oppRecord.Id;
            this.contract.AccountId = oppRecord.AccountId;
            this.contract.RecordTypeId = rt.Id;
            
            //get list of available contacts for contract creation
            contactToemailJson = '{';
            List<String> l_json = new List<String>();
            
            for(Contact item : [SELECT Id,Name, Email, title FROM Contact WHERE AccountId =:oppRecord.AccountId]) {
                contacts.add(new SelectOption(item.Id, (String.isBlank(item.title) == false ? item.title : 'Employee') +': '+ item.Name));
                if(item.Email != null) {
                    emails.add(new SelectOption(item.Email, item.Email));
                }
                l_json.add('"' + item.Id + '":"' + item.Email + '"');
    
            }
            contactToemailJson += String.Join(l_json,',');
            contactToemailJson += '}';
        } else {
            contactToemailJson = '{';
            List<String> l_json = new List<String>();
            for(Contact item : [SELECT Id,Name, Email, title FROM Contact WHERE AccountId =:contract.AccountId]) {
                contacts.add(new SelectOption(item.Id, (String.isBlank(item.title) == false ? item.title : 'Employee') +': '+item.Name));
                if(item.Email != null) {
                    emails.add(new SelectOption(item.Email, item.Email));
                }
                l_json.add('"'+item.Id+'":"'+item.Email+'"');
    
            }
            contactToemailJson+=String.Join(l_json,',');
            contactToemailJson+='}';
        }
        
        Date todayDate = Date.Today();
        String currentDate =  m_dates.get(todayDate.month()) + ' '+ todayDate.year();
        
        if (todayDate > Date.newinstance(todayDate.year(), todayDate.month(), 1)) {
            todayDate = Date.newinstance(todayDate.year(), todayDate.month(), 1).addMonths(1);
        }
        
        for(Integer i=1; i<12; i++){
            String monthvalue = m_dates.get(todayDate.month()) + ' '+ todayDate.year();
            effectivedays.add(new SelectOption(todayDate.format(), monthvalue));
            todayDate = todayDate.addMonths(1);
        }
    }
    
    public static List<SelectOption> getMigrationModelValues(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Contract.Migration_Model__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    
    public static List<SelectOption> getPackageSizeValues(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Contract.Package_Size__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    
    public PageReference saveAction(){
        if(this.contract.Id == null){
            contract.Old_Contract__c = contractId;
        }
        upsert contract;
        return new PageReference('/' + contract.Id);
    }
    
    public Map<Integer, String> m_dates = new Map<Integer, String>{
        1 => '1st of January',
        2 => '1st of February',
        3 => '1st of March',
        4 => '1st of April',
        5 => '1st of May',
        6 => '1st of June',
        7 => '1st of July',
        8 => '1st of August',
        9 => '1st of September',
        10 => '1st of October',
        11 => '1st of November',
        12 => '1st of December'
    };
}