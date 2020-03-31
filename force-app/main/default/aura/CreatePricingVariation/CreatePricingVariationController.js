({
	init: function (component, event, helper) {
        helper.getContractStatus(component);
    },
      closeAction: function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})