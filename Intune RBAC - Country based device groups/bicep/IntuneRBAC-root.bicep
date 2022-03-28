param connections_SharePointOnline_name string = 'SharePointOnline'
param workflows_IntuneRBAC_main_name string = 'IntuneRBAC-LogicApp'
param userAssignedIdentities_IntuneRBAC_Identity_name string = 'IntuneRBAC-ManagedIdentity'
param ResourceGroupName string
param resourceLocation string


module managedIdentityDeployment 'IntuneRBAC-ManagedIdentity.bicep' = {
  name: 'managedIdentityDeployment'
  params: {
    userAssignedIdentities_IntuneRBAC_Identity_name: userAssignedIdentities_IntuneRBAC_Identity_name
    resourceLocation: resourceLocation
  }
}

module connectionsDeployment 'IntuneRBAC-connections.bicep' = {
  name: 'connectionsDeployment'
  params: {
    connections_SharePointOnline_name: connections_SharePointOnline_name
    resourceLocation: resourceLocation
    ResourceGroupName: ResourceGroupName

  }
}

module MainDeployment 'IntuneRBAC-main.bicep' = {
  name: 'MainDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_IntuneRBAC_Identity_name: userAssignedIdentities_IntuneRBAC_Identity_name
    workflows_IntuneRBAC_main_name: workflows_IntuneRBAC_main_name
    

  }
  dependsOn: [
    managedIdentityDeployment    
    connectionsDeployment                                                   
  ]
}






