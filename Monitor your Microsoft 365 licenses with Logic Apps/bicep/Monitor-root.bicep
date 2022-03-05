param connections_office365_name string = 'office365'
param workflows_Monitor_main_name string = 'M365LicenseMonitoring'
param userAssignedIdentities_Monitor_Identity_name string = 'Monitor-ManagedIdentity'
param resourceLocation string = resourceGroup().location

module managedIdentityDeployment 'Monitor-ManagedIdentity.bicep' = {
  name: 'managedIdentityDeployment'
  params: {
    userAssignedIdentities_Monitor_Identity_name: userAssignedIdentities_Monitor_Identity_name
    resourceLocation: resourceLocation
  }
}

module connectionsDeployment 'Monitor-connections.bicep' = {
  name: 'connectionsDeployment'
  params: {
    connections_office365_name: connections_office365_name
    resourceLocation: resourceLocation
  }
}

module MainDeployment 'Monitor-main.bicep' = {
  name: 'MainDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_Monitor_Identity_name: userAssignedIdentities_Monitor_Identity_name
    workflows_Monitor_main_name: workflows_Monitor_main_name
    connections_office365_name: connections_office365_name

  }
  dependsOn: [
    connectionsDeployment
    managedIdentityDeployment
  ]
}






