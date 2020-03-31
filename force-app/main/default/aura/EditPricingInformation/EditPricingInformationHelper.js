({
	getMessage : function(component) {
        console.log('Start');
		var action = component.get("c.getStatus");
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
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                  "url": "/apex/RC_MSAContract?id="+recordId,
                  "isredirect": "true"
                });
                urlEvent.fire();
            }
           
        });
        $A.enqueueAction(action);
	}
})