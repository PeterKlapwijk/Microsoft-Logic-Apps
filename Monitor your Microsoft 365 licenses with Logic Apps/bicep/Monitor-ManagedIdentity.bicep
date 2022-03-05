param userAssignedIdentities_Monitor_Identity_name string = 'Monitor-ManagedIdentity'
param resourceLocation string 

resource userAssignedIdentities_Monitor_Identity_name_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userAssignedIdentities_Monitor_Identity_name
  location: resourceLocation
}
