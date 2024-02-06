param workflows_WindowsDriverAutoApproval_name string
param resourceLocation string 
param userAssignedIdentities_WINDriverAutoApproval_ManagedIdentity_externalid string = 'WINDriverAutoApproval-ManagedIdentity'

resource workflows_WindowsDriverAutoApprovalv1_0_name_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflows_WindowsDriverAutoApproval_name
  location: resourceLocation
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities/',userAssignedIdentities_WINDriverAutoApproval_ManagedIdentity_externalid)}': {}
    }
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {}
      triggers: {
        Recurrence: {
          recurrence: {
            frequency: 'Week'
            interval: 1
            schedule: {
              weekDays: [
                'Tuesday'
              ]
            }
            startTime: '2024-02-13T01:00:00Z'
            timeZone: 'W. Europe Standard Time'
          }
          evaluatedRecurrence: {
            frequency: 'Week'
            interval: 1
            schedule: {
              weekDays: [
                'Tuesday'
              ]
            }
            startTime: '2024-02-13T01:00:00Z'
            timeZone: 'W. Europe Standard Time'
          }
          type: 'Recurrence'
          conditions: [
            {
              expression: '@and(less(int(utcNow(\'dd\')),15),greater(int(utcNow(\'dd\')),7))'
            }
          ]
        }
      }
      actions: {
        For_each_driver_ID: {
          foreach: '@body(\'Parse_JSON_GET_driverInventories\')?[\'value\']'
          actions: {
            HTTP_POST_executeAction: {
              runAfter: {}
              type: 'Http'
              inputs: {
                authentication: {
                  audience: 'https://graph.microsoft.com'
                  identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_WINDriverAutoApproval_ManagedIdentity_externalid)
                  type: 'ManagedServiceIdentity'
                }
                body: {
                  actionName: 'approve'
                  deploymentDate: '@{formatDateTime(utcNow(), \'yyyy-MM-ddTHH:mm:ssZ\')}'
                  driverIds: [
                    '@{items(\'For_each_driver_ID\')?[\'id\']}'
                  ]
                }
                method: 'POST'
                uri: 'https://graph.microsoft.com/beta/deviceManagement/windowsDriverUpdateProfiles/@{variables(\'windowsDriverUpdateProfilesID\')}/executeAction'
              }
            }
          }
          runAfter: {
            Parse_JSON_GET_driverInventories: [
              'Succeeded'
            ]
          }
          type: 'Foreach'
        }
        HTTP_GET_driverInventories: {
          runAfter: {
            Initialize_variable: [
              'Succeeded'
            ]
          }
          type: 'Http'
          inputs: {
            authentication: {
              audience: 'https://graph.microsoft.com'
              identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_WINDriverAutoApproval_ManagedIdentity_externalid)
              type: 'ManagedServiceIdentity'
            }
            method: 'GET'
            uri: 'https://graph.microsoft.com/beta/deviceManagement/windowsDriverUpdateProfiles/@{variables(\'windowsDriverUpdateProfilesID\')}/driverInventories?$filter=(category%20eq%20%27recommended%27)%20and%20(approvalStatus%20eq%20%27needsReview%27)'
          }
        }
        Initialize_variable: {
          runAfter: {}
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'windowsDriverUpdateProfilesID'
                type: 'string'
                value: 'changeme'
              }
            ]
          }
        }
        Parse_JSON_GET_driverInventories: {
          runAfter: {
            HTTP_GET_driverInventories: [
              'Succeeded'
            ]
          }
          type: 'ParseJson'
          inputs: {
            content: '@body(\'HTTP_GET_driverInventories\')'
            schema: {
              properties: {
                '@@odata.context': {
                  type: 'string'
                }
                '@@odata.count': {
                  type: 'integer'
                }
                value: {
                  items: {
                    properties: {
                      applicableDeviceCount: {
                        type: 'integer'
                      }
                      approvalStatus: {
                        type: 'string'
                      }
                      category: {
                        type: 'string'
                      }
                      deployDateTime: {
                        type: 'string'
                      }
                      driverClass: {
                        type: 'string'
                      }
                      id: {
                        type: 'string'
                      }
                      manufacturer: {
                        type: 'string'
                      }
                      name: {
                        type: 'string'
                      }
                      releaseDateTime: {
                        type: 'string'
                      }
                      version: {
                        type: 'string'
                      }
                    }
                    required: [
                      'id'
                      'name'
                      'version'
                      'manufacturer'
                      'releaseDateTime'
                      'driverClass'
                      'applicableDeviceCount'
                      'approvalStatus'
                      'category'
                      'deployDateTime'
                    ]
                    type: 'object'
                  }
                  type: 'array'
                }
              }
              type: 'object'
            }
          }
        }
      }
      outputs: {}
    }
    parameters: {}
  }
}
