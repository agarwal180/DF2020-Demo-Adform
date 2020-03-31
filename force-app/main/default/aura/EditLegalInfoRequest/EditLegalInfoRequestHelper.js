({
	onOkClickHelper : function(component, event, helper) {
		var recrdId=component.get("v.recordId");
        var action = component.get("c.getTemplateID");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var templateId = response.getReturnValue();
                var url='/_ui/core/email/author/EmailAuthor?p3_lkid='+recrdId+'&retURL=/'+recrdId+'&template_id='+templateId+'&p24=&p5=';
        		window.location =url;
            }
        });
        $A.enqueueAction(action);
	}
})