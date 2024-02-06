param userAssignedIdentities_WINDriverAutoApproval_ManagedIdentity_externalid string = 'WINDriverAutoApproval-ManagedIdentity'
param resourceLocation string 

resource userAssignedIdentities_WINDriverAutoApproval_ManagedIdentity_externalid_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userAssignedIdentities_WINDriverAutoApproval_ManagedIdentity_externalid
  location: resourceLocation
}
