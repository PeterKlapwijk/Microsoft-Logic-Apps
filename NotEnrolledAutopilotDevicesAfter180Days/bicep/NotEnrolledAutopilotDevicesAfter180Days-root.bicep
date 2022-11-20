param connections_excelonlinebusiness_name string = 'excelonlinebusiness'
param connections_office365_name string = 'office365'
param connections_SharePointOnline_name string = 'SharePointOnline'
param workflows_NotEnrolledAutopilotDevicesAfter180Days_name string = 'NotEnrolledAutopilotDevicesAfter180Days-LogicApp'
param userAssignedIdentities_Autopilot180days_Identity_name string = 'Autopilot180days-ManagedIdentity'
param ResourceGroupName string
param resourceLocation string


module managedIdentityDeployment 'NotEnrolledAutopilotDevicesAfter180Days-ManagedIdentity.bicep' = {
  name: 'managedIdentityDeployment'
  params: {
    userAssignedIdentities_Autopilot180days_Identity_name: userAssignedIdentities_Autopilot180days_Identity_name
    resourceLocation: resourceLocation
  }
}

module connectionsDeployment 'NotEnrolledAutopilotDevicesAfter180Days-connections.bicep' = {
  name: 'connectionsDeployment'
  params: {
    connections_office365_name: connections_office365_name
    resourceLocation: resourceLocation
    ResourceGroupName: ResourceGroupName

  }
}

module MainDeployment 'NotEnrolledAutopilotDevicesAfter180Days-main.bicep' = {
  name: 'MainDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_Autopilot180days_Identity_name: userAssignedIdentities_Autopilot180days_Identity_name
    workflows_NotEnrolledAutopilotDevicesAfter180Days_name: workflows_NotEnrolledAutopilotDevicesAfter180Days_name
    connections_excelonlinebusiness_name: connections_excelonlinebusiness_name
    connections_office365_name: connections_office365_name
    connections_SharePointOnline_name: connections_SharePointOnline_name

  }
  dependsOn: [
    connectionsDeployment
    managedIdentityDeployment                                                       
  ]
}






