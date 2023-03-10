param connections_office365_name string = 'office365'
param workflows_LOBAppsExpiryNotifications_name string = 'iOSLOBAppExpiryNotifications-LogicApp'
param userAssignedIdentities_LOBAppExpiryNotifications_Identity_name string = 'LOBAppExpiryNotifications-ManagedIdentity'
param ResourceGroupName string
param resourceLocation string


module managedIdentityDeployment 'iOSLOBAppExpiryNotifications-ManagedIdentity.bicep' = {
  name: 'managedIdentityDeployment'
  params: {
    userAssignedIdentities_LOBAppExpiryNotifications_Identity_name: userAssignedIdentities_LOBAppExpiryNotifications_Identity_name
    resourceLocation: resourceLocation
  }
}

module connectionsDeployment 'iOSLOBAppExpiryNotifications-connections.bicep' = {
  name: 'connectionsDeployment'
  params: {
    connections_office365_name: connections_office365_name
    resourceLocation: resourceLocation
    ResourceGroupName: ResourceGroupName

  }
}

module MainDeployment 'iOSLOBAppExpiryNotifications-main.bicep' = {
  name: 'MainDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_LOBAppExpiryNotifications_Identity_name: userAssignedIdentities_LOBAppExpiryNotifications_Identity_name
    workflows_LOBAppsExpiryNotifications_name: workflows_LOBAppsExpiryNotifications_name
    connections_office365_name: connections_office365_name


  }
  dependsOn: [
    connectionsDeployment
    managedIdentityDeployment                                                       
  ]
}






