param workflows_NotificationsMissingWUDevicesReport_name string = 'NotificationsMissingWUDevicesReport-LogicApp'
param connections_excelonlinebusiness_name string = 'excelonlinebusiness'
param connections_office365_name string = 'office365'
param connections_SharePoint_name string = 'SharePointOnline'
param userAssignedIdentities_NotificationsMissingWUDevicesReport_Identity_name string = 'NotificationsMissingWUDevicesReport-ManagedIdentity'
param ResourceGroupName string
param resourceLocation string


module managedIdentityDeployment 'NotificationsMissingWUDevicesReport-ManagedIdentity.bicep' = {
  name: 'managedIdentityDeployment'
  params: {
    userAssignedIdentities_NotificationsMissingWUDevicesReport_Identity_name: userAssignedIdentities_NotificationsMissingWUDevicesReport_Identity_name
    resourceLocation: resourceLocation
  }
}

module connectionsDeployment 'NotificationsMissingWUDevicesReport-connections.bicep' = {
  name: 'connectionsDeployment'
  params: {
    connections_office365_name: connections_office365_name
    resourceLocation: resourceLocation
    ResourceGroupName: ResourceGroupName

  }
}

module MainDeployment 'NotificationsMissingWUDevicesReport-main.bicep' = {
  name: 'MainDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_NotificationsMissingWUDevicesReport_Identity_name: userAssignedIdentities_NotificationsMissingWUDevicesReport_Identity_name
    workflows_NotificationsMissingWUDevicesReport_name: workflows_NotificationsMissingWUDevicesReport_name
    connections_excelonlinebusiness_name: connections_excelonlinebusiness_name
    connections_office365_name: connections_office365_name
    connections_SharePoint_name: connections_SharePoint_name

  }
  dependsOn: [
    connectionsDeployment
    managedIdentityDeployment                                                       
  ]
}






