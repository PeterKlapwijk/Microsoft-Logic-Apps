param connections_excelonlinebusiness_name string = 'excelonlinebusiness'
param connections_office365_name string = 'office365'
param connections_SharePointOnline_name string = 'SharePointOnline'
param workflows_WINDriverApprovalReport_name string = 'WindowsDriverApprovalReport-LogicApp'
param userAssignedIdentities_WINDriverApprovalReport_Identity_name string = 'WINDriverApprovalReport-ManagedIdentity'
param ResourceGroupName string
param resourceLocation string


module managedIdentityDeployment 'WindowsDriverApprovalReport-ManagedIdentity.bicep' = {
  name: 'managedIdentityDeployment'
  params: {
    userAssignedIdentities_WINDriverApprovalReport_Identity_name: userAssignedIdentities_WINDriverApprovalReport_Identity_name
    resourceLocation: resourceLocation
  }
}

module connectionsDeployment 'WindowsDriverApprovalReport-connections.bicep' = {
  name: 'connectionsDeployment'
  params: {
    connections_SharePointOnline_name: connections_SharePointOnline_name
    resourceLocation: resourceLocation
    ResourceGroupName: ResourceGroupName

  }
}

module MainDeployment 'WindowsDriverApprovalReport-main.bicep' = {
  name: 'MainDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_WINDriverApprovalReport_Identity_name: userAssignedIdentities_WINDriverApprovalReport_Identity_name
    workflows_WINDriverApprovalReport_name: workflows_WINDriverApprovalReport_name
    connections_excelonlinebusiness_name: connections_excelonlinebusiness_name
    connections_office365_name: connections_office365_name
    connections_SharePointOnline_name: connections_SharePointOnline_name


  }
  dependsOn: [
    managedIdentityDeployment    
    connectionsDeployment                                                   
  ]
}





