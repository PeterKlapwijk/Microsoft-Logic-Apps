param userAssignedIdentities_Autopilot180days_Identity_name string = 'Autopilot180days-ManagedIdentity'
param resourceLocation string 

resource userAssignedIdentities_Autopilot180days_Identity_name_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userAssignedIdentities_Autopilot180days_Identity_name
  location: resourceLocation
}
