public with sharing class ContactContract {

    public Id selectedContract { get; set;}
    public List<RecordType> l_recordTypesInfo {get; set; }
    public List<SelectOption> l_recordtypes { get; set; }
    public Opportunity oppRecord { get; set;}
    public Id ioContactId;
    public Id msaContactId;
    public Id mServicesId;
    
  public ContactContract (ApexPages.StandardController con){
    this.oppRecord = (Opportunity) con.getRecord();
    Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contract; 
    Map<String,Schema.RecordTypeInfo> m_recordTypes = cfrSchema.getRecordTypeInfosByName();
    Set<Id> s_rtIds = new Set<Id>();
    for(Schema.RecordTypeInfo item : m_recordTypes.values()) {
        if (item.isAvailable()) {
            s_rtIds.add(item.getRecordTypeId());
        }
    }
    l_recordTypesInfo  = [select id, DeveloperName, Name, description FROM RecordType WHERE SobjectType= 'Contract' AND isActive= true AND DeveloperName IN ('IO','BMSA', 'Migration_Services_Addendum') AND Id IN:s_rtIds];
    l_recordtypes  = new List<SelectOption>();
    for(RecordType item : l_recordTypesInfo) {
        if (item.developerName == 'IO'){
            ioContactId = item.Id;
        }
        if (item.developerName == 'BMSA') {
            msaContactId = item.Id;
        }
        if (item.developerName == 'Migration_Services_Addendum') {
            mServicesId = item.Id;
        }
        l_recordtypes.add(new SelectOption(item.Id, item.Name));
    }
  }
  
  public PageReference cancelAction(){
    return new PageReference('/'+oppRecord.Id);
  }
  
  public PageReference selectAction(){
      PageReference reference = null;
      if(msaContactId == selectedContract) {
         reference = new PageReference('/apex/RC_MSAcontract?oppId=' + oppRecord.Id);
      }
      if(ioContactId == selectedContract) {
         reference = new PageReference('/apex/ContactSelectionForContract?id=' + oppRecord.Id);
      }
      if(mServicesId == selectedContract) {
          reference = new PageReference('/apex/MigrationServices?oppId=' + oppRecord.Id);
      }
      return reference;
    
  }
}