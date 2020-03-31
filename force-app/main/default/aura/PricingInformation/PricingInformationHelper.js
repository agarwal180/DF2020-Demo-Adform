({
	getStatus : function(component) {
		var action = component.get("c.getApprovalStatus");
        var recordId = component.get("v.recordId");
        action.setParams({
            recId  : recordId
        });
        action.setCallback(this, function(response) {
            var res = response.getReturnValue();
            if (res != 'SUCCESS') {
                component.set('v.message',res);
            }
            else {
                component.set("v.truthy", true);
                component.set('v.message','Pricing Information Generating...');
                var delay=4000; //4 seconds
                setTimeout(function() { var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": recordId,
                    "slideDevName": "related"
                });
                navEvt.fire();
                }, delay);
            }
           
        });
        $A.enqueueAction(action);
	}
})