({
	init: function (component, event, helper) {
        helper.getStatus(component);
    },
      closeAction: function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})