param userAssignedIdentities_WINDriverApprovalReport_Identity_name string = 'WINDriverApprovalReport-ManagedIdentity'
param resourceLocation string 

resource userAssignedIdentities_WINDriverApprovalReport_Identity_name_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userAssignedIdentities_WINDriverApprovalReport_Identity_name
  location: resourceLocation
}
