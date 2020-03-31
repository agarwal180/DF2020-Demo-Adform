public with sharing class CVS_NewContractPriceController {
    public Contract_Price__c cprecord { get; set;}
    public List<SelectOption> startdate { get; set; }
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


    public CVS_NewContractPriceController(ApexPages.StandardController con){
        if (Test.isRunningTest() == false) {
            con.addFields(new List<String>{'Starting_Date__c'});
        }
        this.cprecord = (Contract_Price__c) con.getRecord();
        this.cprecord.Starting_Date__c = null;
        startdate =  new List<SelectOption>{new SelectOption('', '--Please select Date--')};
        Date todayDate = Date.Today();
        String currentDate =  m_dates.get(todayDate.month()) + ' '+ todayDate.year();
        //startdate.add( new SelectOption( Date.newinstance(todayDate.year(), todayDate.month(), 1).format(), currentDate));
        
        if (todayDate > Date.newinstance(todayDate.year(), todayDate.month(), 1)) {
            todayDate = Date.newinstance(todayDate.year(), todayDate.month(), 1).addMonths(1);
        }
        for(Integer i=1; i<12; i++){
            String monthvalue = m_dates.get(todayDate.month()) + ' '+ todayDate.year();
            startdate.add(new SelectOption(todayDate.format(), monthvalue));
            todayDate = todayDate.addMonths(1);
        }
    }
    
    public PageReference saveAction() {
        Contract_Price__c cprecord_new = cprecord.clone(false, false, false, false);
        insert cprecord_new;
        Contract_Price__c cprecord_old = [SELECT ID,Ending_Date__c FROM  Contract_Price__c WHERE Id=:cprecord.Id];
        if (cprecord_new.Starting_Date__c != null) {
            cprecord_old.Ending_Date__c = cprecord_new.Starting_Date__c.addDays(-1);
            update cprecord_old;
        }
        return new PageReference('/'+cprecord_new.Id);
    }
}