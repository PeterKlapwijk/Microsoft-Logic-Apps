param connections_office365_name string = 'office365'
param workflows_Monitor_main_name string = 'Monitor-LogicApp'
param userAssignedIdentities_Monitor_Identity_name string = 'Monitor-ManagedIdentity'
param resourceGroupName string
param resourceLocation string = resourceGroup().location
param EmailFrom string
param EmailTo string

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
    ResourceGroupName: resourceGroupName
    EmailFrom:EmailFrom
  }
}

module MainDeployment 'Monitor-main.bicep' = {
  name: 'MainDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_Monitor_Identity_name: userAssignedIdentities_Monitor_Identity_name
    workflows_Monitor_main_name: workflows_Monitor_main_name
    connections_office365_name: connections_office365_name
    EmailFrom:EmailFrom
    EmailTo: EmailTo

  }
  dependsOn: [
    connectionsDeployment
    managedIdentityDeployment                                                       
  ]
}






