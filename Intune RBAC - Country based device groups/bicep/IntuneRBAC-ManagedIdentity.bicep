param userAssignedIdentities_IntuneRBAC_Identity_name string = 'IntuneRBAC-ManagedIdentity'
param resourceLocation string 

resource userAssignedIdentities_IntuneRBAC_Identity_name_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userAssignedIdentities_IntuneRBAC_Identity_name
  location: resourceLocation
}
