param userAssignedIdentities_IntuneServiceMsg_Identity_name string = 'IntuneServiceMsg-ManagedIdentity'
param resourceLocation string 

resource userAssignedIdentities_IntuneServiceMsg_Identity_name_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userAssignedIdentities_IntuneServiceMsg_Identity_name
  location: resourceLocation
}
