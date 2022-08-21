param userAssignedIdentities_MonitorLicense_Identity_name string = 'MonitorLicense-ManagedIdentity'
param resourceLocation string 

resource userAssignedIdentities_MonitorLicense_Identity_name_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userAssignedIdentities_MonitorLicense_Identity_name
  location: resourceLocation
}
