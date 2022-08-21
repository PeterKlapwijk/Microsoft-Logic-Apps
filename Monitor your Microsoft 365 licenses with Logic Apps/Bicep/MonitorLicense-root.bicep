param connections_office365_name string = 'office365'
param workflows_MonitorLicense_main_name string = 'MonitorLicense-LogicApp'
param userAssignedIdentities_MonitorLicense_Identity_name string = 'MonitorLicense-ManagedIdentity'
param ResourceGroupName string
param resourceLocation string


module managedIdentityDeployment 'MonitorLicense-ManagedIdentity.bicep' = {
  name: 'managedIdentityDeployment'
  params: {
    userAssignedIdentities_MonitorLicense_Identity_name: userAssignedIdentities_MonitorLicense_Identity_name
    resourceLocation: resourceLocation
  }
}

module connectionsDeployment 'MonitorLicense-connections.bicep' = {
  name: 'connectionsDeployment'
  params: {
    connections_office365_name: connections_office365_name
    resourceLocation: resourceLocation
    ResourceGroupName: ResourceGroupName

  }
}

module MainDeployment 'MonitorLicense-main.bicep' = {
  name: 'MainDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_MonitorLicense_Identity_name: userAssignedIdentities_MonitorLicense_Identity_name
    workflows_MonitorLicense_main_name: workflows_MonitorLicense_main_name
    connections_office365_name: connections_office365_name


  }
  dependsOn: [
    connectionsDeployment
    managedIdentityDeployment                                                       
  ]
}






