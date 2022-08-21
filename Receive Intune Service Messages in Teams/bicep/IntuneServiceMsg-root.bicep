param workflows_IntuneServiceMsg_name string = 'IntuneServiceMsg-LogicApp'
param userAssignedIdentities_IntuneServiceMsg_Identity_name string = 'IntuneServiceMsg-ManagedIdentity'
param resourceLocation string


module managedIdentityDeployment 'IntuneServiceMsg-ManagedIdentity.bicep' = {
  name: 'managedIdentityDeployment'
  params: {
    userAssignedIdentities_IntuneServiceMsg_Identity_name: userAssignedIdentities_IntuneServiceMsg_Identity_name
    resourceLocation: resourceLocation
  }
}

module MainDeployment 'IntuneServiceMsg-main.bicep' = {
  name: 'MainDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_IntuneServiceMsg_Identity_name: userAssignedIdentities_IntuneServiceMsg_Identity_name
    workflows_IntuneServiceMsg_name: workflows_IntuneServiceMsg_name

  }
  dependsOn: [
    managedIdentityDeployment                                                       
  ]
}
