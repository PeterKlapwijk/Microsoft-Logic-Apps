param connections_office365_name string = 'office365'
param workflows_DefenderforEndpointSoftwareUpdateReport_main_name string = 'DefenderforEndpointSoftwareUpdateReport-LogicApp'
param userAssignedIdentities_DefenderforEndpointReporting_ManagedIdentity_name string = 'DefenderforEndpointReporting-ManagedIdentity'
param ResourceGroupName string
param resourceLocation string


module managedIdentityDeployment 'DefenderSoftwareUpdateReport-ManagedIdentity.bicep' = {
  name: 'managedIdentityDeployment'
  params: {
    userAssignedIdentities_DefenderforEndpoint_ManagedIdentity_name: userAssignedIdentities_DefenderforEndpointReporting_ManagedIdentity_name
    resourceLocation: resourceLocation
  }
}

module connectionsDeployment 'DefenderSoftwareUpdateReport-connections.bicep' = {
  name: 'connectionsDeployment'
  params: {
    connections_office365_name: connections_office365_name
    resourceLocation: resourceLocation
    ResourceGroupName: ResourceGroupName

  }
}

module MainDeployment 'DefenderSoftwareUpdateReport-main.bicep' = {
  name: 'MainDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_DefenderforEndpointReporting_ManagedIdentity_name: userAssignedIdentities_DefenderforEndpointReporting_ManagedIdentity_name
    workflows_DefenderforEndpointSoftwareUpdateReport_name: workflows_DefenderforEndpointSoftwareUpdateReport_main_name
    connections_office365_name: connections_office365_name


  }
  dependsOn: [
    connectionsDeployment
    managedIdentityDeployment                                                       
  ]
}






