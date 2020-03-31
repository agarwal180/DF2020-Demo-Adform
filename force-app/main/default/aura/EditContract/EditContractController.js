({
    init: function (component, event, helper) {
        var recordId = component.get("v.recordId");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/apex/MigrationServices?id="+recordId,
            "isredirect": "true"
        });
        urlEvent.fire();
    }
})