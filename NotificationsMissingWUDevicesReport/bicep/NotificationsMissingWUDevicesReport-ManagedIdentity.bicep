param userAssignedIdentities_NotificationsMissingWUDevicesReport_Identity_name string = 'NotificationsMissingWUDevicesReport-ManagedIdentity'
param resourceLocation string 

resource userAssignedIdentities_NotificationsMissingWUDevicesReport_Identity_name_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userAssignedIdentities_NotificationsMissingWUDevicesReport_Identity_name
  location: resourceLocation
}
