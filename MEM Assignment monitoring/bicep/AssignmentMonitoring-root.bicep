param connections_excelonlinebusiness_name string = 'excelonlinebusiness'
param connections_office365_name string = 'office365'
param connections_SharePoint_name string = 'SharePointOnline'
param workflows_MEMAssignmentMonitoring_name string = 'MEMAssignmentMonitoring-LogicApp'
param userAssignedIdentities_MEMAssignment_Identity_name string = 'MEMAssignment-ManagedIdentity'
param ResourceGroupName string
param resourceLocation string


module managedIdentityDeployment 'AssignmentMonitoring-ManagedIdentity.bicep' = {
  name: 'managedIdentityDeployment'
  params: {
    userAssignedIdentities_Monitor_Identity_name: userAssignedIdentities_MEMAssignment_Identity_name
    resourceLocation: resourceLocation
  }
}

module connectionsDeployment 'AssignmentMonitoring-connections.bicep' = {
  name: 'connectionsDeployment'
  params: {
    connections_office365_name: connections_office365_name
    resourceLocation: resourceLocation
    ResourceGroupName: ResourceGroupName

  }
}

module MainDeployment 'AssignmentMonitoring-main.bicep' = {
  name: 'MainDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_MEMAssignment_Identity_name: userAssignedIdentities_MEMAssignment_Identity_name
    workflows_MEMAssignmentMonitoring_name: workflows_MEMAssignmentMonitoring_name
    connections_excelonlinebusiness_name: connections_excelonlinebusiness_name
    connections_office365_name: connections_office365_name
    connections_SharePoint_name: connections_SharePoint_name

  }
  dependsOn: [
    connectionsDeployment
    managedIdentityDeployment                                                       
  ]
}






