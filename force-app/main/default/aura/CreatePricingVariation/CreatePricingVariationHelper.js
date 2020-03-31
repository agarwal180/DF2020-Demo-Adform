({
	getContractStatus : function(component) {
        var action=component.get("c.getContractStatus");
        var recordId=component.get("v.recordId");
        action.setParams({
            recId : recordId
        });
        action.setCallback(this,function(response){
             var res = response.getReturnValue();
            if (res != 'SUCCESS') {
                component.set('v.message',res);
            }else{
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                  "url": "/apex/RC_MSAContract?variation=1&id="+recordId,
                  "isredirect": "true"
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
	}
})