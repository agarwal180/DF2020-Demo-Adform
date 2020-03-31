({
	init: function (component, event, helper) {
        helper.getMessage(component);
    },
      closeAction: function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})