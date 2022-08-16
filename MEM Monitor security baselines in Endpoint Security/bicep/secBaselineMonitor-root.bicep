param workflows_secBaselineMonitor_name string = 'secBaselineMonitor-LogicApp'
param userAssignedIdentities_secBaselineMonitor_Identity_name string = 'SecBaselineMonitor-ManagedIdentity'
param resourceLocation string


module managedIdentityDeployment 'secBaselineMonitor-ManagedIdentity.bicep' = {
  name: 'managedIdentityDeployment'
  params: {
    userAssignedIdentities_Monitor_Identity_name: userAssignedIdentities_secBaselineMonitor_Identity_name
    resourceLocation: resourceLocation
  }
}

module MainDeployment 'secBaselineMonitor-main.bicep' = {
  name: 'MainDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_SecBaselineMonitor_Identity_name: userAssignedIdentities_secBaselineMonitor_Identity_name
    workflows_MonitorSecurityBaselinesEndpointSecurity_name: workflows_secBaselineMonitor_name

  }
  dependsOn: [
    managedIdentityDeployment                                                       
  ]
}






