({
	onOkClick : function(component, event, helper) {
        helper.onOkClickHelper(component, event, helper);
	},
    closeAction : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
})