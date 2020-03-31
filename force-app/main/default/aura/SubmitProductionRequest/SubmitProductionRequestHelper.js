({
	getMessage : function(component) {
		var action = component.get("c.getMessage");
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
                component.set('v.message','Redirecting to Creative Form');
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                  "url": "/apex/Creative_form?scontrolCaching=1&id="+recordId,
                  "isredirect": "true"
                });
                urlEvent.fire();
            }
           
        });
        $A.enqueueAction(action);
	}
})