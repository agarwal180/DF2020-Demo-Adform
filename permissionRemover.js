const convert = require('xml-js');
const filterxml = require('filterxml');
const fs = require('fs');

//profiles paths
const profiles = [
    'force-app/main/default/profiles/Adform Billing User.profile-meta.xml',
    'force-app/main/default/profiles/Adform Data Admin.profile-meta.xml',
    'force-app/main/default/profiles/Adform Standard User.profile-meta.xml',
    'force-app/main/default/profiles/Adform System Administrator.profile-meta.xml',
    'force-app/main/default/profiles/Admin.profile-meta.xml',
    'force-app/main/default/profiles/Doxis API.profile-meta.xml',
    'force-app/main/default/profiles/System User.profile-meta.xml'
];

//permission names to remove
const permissions = [
    'AllowViewKnowledge',
    'AllowUniversalSearch',
    'ConsentApiUpdate',
    'EditPublicReports',
    'EditReports',
    'ManageEntitlements',
    'ManageKnowledge',
    'ManageKnowledgeImportExport',
    'ShareInternalArticles',
    'EditKnowledge',
    'ManageDashboards',
    'ManageSearchPromotionRules',
    'ManageHubConnections',
    'ManageCMS',
    'ViewFlowUsageAndFlowEventData',
    'EditBillingInfo',
    'CanUseNewDashboardBuilder',
    'Packaging2PromoteVersion',
    'ViewUserPII',
    'ManageDynamicDashboards',
    'ModifyAllData',
    'InstallPackaging',
    'Case.EntitlementId',
    'Case.IsSelfServiceClosed',
    'Case.IsStopped',
    'Case.IsVisibleInSelfService',
    'Case.MilestoneStatus',
    'Case.MilestoneStatusIcon',
    'Case.ProductId',
    'Case.SlaExitDate',
    'Case.SlaStartDate',
    'Case.StopStartDate',
    'Case.IsVisibleInCss',
    'Contact.CanAllowPortalSelfReg'
];

profiles.forEach(profile => {
    //xml file
    const xml = fs.readFileSync(profile, 'utf8');
    deletePermissions(xml, profile);
});

function deletePermissions(xml, profile) {
    //converts xml to JSON
    const result = convert.xml2js(xml);

    //removes permissions which exists in permissions array
    result.elements[0].elements.forEach(element => {
        if(element.name === 'fieldPermissions'){
            element.elements.forEach(field => {
                if(field.name === 'field'){
                    if(permissions.includes(field.elements[0].text)){
                        delete element.name;
                        delete element.elements;
                    }
                }
            });
        }
        if(element.name === 'userPermissions'){
            element.elements.forEach(field => {
                if(field.name === 'name'){
                    if(permissions.includes(field.elements[0].text)){
                        delete element.name;
                        delete element.elements;
                    }
                }
            })
        }
    });

    const options = {spaces: 2};

    //converts json to xml
    const newXml = convert.js2xml(result, options);

    const patterns = ["x:undefined"];
    const namespaces = {
        'x': 'http://soap.sforce.com/2006/04/metadata',
    };

    //removes undefined elements
    filterxml(newXml, patterns, namespaces, function (err, xmlOut) {
        if(err){
            throw err;
        }
        //overrides profile with removed permissions
        fs.writeFileSync(profile, xmlOut);
    });
}
