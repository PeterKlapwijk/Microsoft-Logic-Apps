param workflows_WindowsDriverAutoApproval_name string = 'WindowsDriverAutoApproval-LogicApp'
param userAssignedIdentities_WINDriverAutoApproval_ManagedIdentity_externalid string = 'WINDriverAutoApproval-ManagedIdentity'
param resourceLocation string


module managedIdentityDeployment 'WindowsDriverAutoApprovalPatchTuesday-ManagedIdentity.bicep' = {
  name: 'managedIdentityDeployment'
  params: {
    userAssignedIdentities_WINDriverAutoApproval_ManagedIdentity_externalid: userAssignedIdentities_WINDriverAutoApproval_ManagedIdentity_externalid
    resourceLocation: resourceLocation
  }
}

module MainDeployment 'WindowsDriverAutoApprovalPatchTuesday-main.bicep' = {
  name: 'MainDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_WINDriverAutoApproval_ManagedIdentity_externalid: userAssignedIdentities_WINDriverAutoApproval_ManagedIdentity_externalid
    workflows_WindowsDriverAutoApproval_name: workflows_WindowsDriverAutoApproval_name

  }
  dependsOn: [
    managedIdentityDeployment                                                    
  ]
}
