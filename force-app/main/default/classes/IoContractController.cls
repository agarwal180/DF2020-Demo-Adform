public with sharing class IoContractController {
	public class Device {
		public Boolean isSelected { get; set; }
		public String deviceName { get; set; }
	}
	public List<Device> devices { get; set; }
	public IoContractController(ApexPages.StandardController con){
		List<String> listValues = new List<String>{'Devices__c'};
		  if(!test.isRunningTest()) {
			con.addFields(listValues);
		  }
		Contract contractRecord = (Contract) con.getRecord();
		List<String> currentValues = new List<String>();
		if(String.isNotEmpty(contractRecord.Devices__c)) {
			currentValues = contractRecord.Devices__c.split(';');
		}
		List<Schema.PicklistEntry> ple = Contract.Devices__c.getDescribe().getPicklistValues();
		devices = new List<Device>();
		for(Schema.PicklistEntry item : ple) {
			Device tempDevice = new Device();
			tempDevice.deviceName = item.getLabel();
			tempDevice.isSelected = false;
			for(String dItem : currentValues) {
				if(dItem == item.getValue()) {
					tempDevice.isSelected = true;
					break;
				}
			}
			devices.add(tempDevice);
		}
		
	}
}