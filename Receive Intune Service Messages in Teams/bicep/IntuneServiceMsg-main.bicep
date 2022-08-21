param workflows_IntuneServiceMsg_name string
param userAssignedIdentities_IntuneServiceMsg_Identity_name string = 'IntuneServiceMsg-ManagedIdentity'
param resourceLocation string

resource workflows_IntuneServiceMsg_name_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflows_IntuneServiceMsg_name
  location: resourceLocation
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities/',userAssignedIdentities_IntuneServiceMsg_Identity_name)}': {}      
    }
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
      }
      triggers: {
        Recurrence: {
          recurrence: {
            frequency: 'Hour'
            interval: 1
          }
          evaluatedRecurrence: {
            frequency: 'Hour'
            interval: 1
          }
          type: 'Recurrence'
        }
      }
      actions: {
        For_each: {
          foreach: '@body(\'Parse_JSON_Select_values\')'
          actions: {
            Condition: {
              actions: {
                HTTP_POST_Teams_Webhook: {
                  runAfter: {
                  }
                  type: 'Http'
                  inputs: {
                    body: {
                      text: '**Title:** @{items(\'For_each\')[\'Title\']}\n\n **ID:** @{items(\'For_each\')[\'ID\']}\n\n **Impact Description:** @{items(\'For_each\')[\'Impact Description\']}\n\n **Classification:** @{items(\'For_each\')[\'Classification\']}\n\n **Start Time:** @{items(\'For_each\')[\'Start Date Time\']}\n\n **Last Modified Time:** @{items(\'For_each\')[\'Last Modified Time\']}\n\n **Status:** @{items(\'For_each\')[\'Status\']}\n\n **Is Resolved:** @{items(\'For_each\')[\'Is Resolved\']}'
                      title: '@{items(\'For_each\')[\'ID\']} '
                    }
                    headers: {
                      'Content-Type': 'application/json'
                    }
                    method: 'POST'
                    uri: ''
                  }
                }
              }
              runAfter: {
              }
              expression: {
                or: [
                  {
                    greater: [
                      '@items(\'For_each\')[\'Last Modified Time\']'
                      '@addHours(utcNow(),-1)'
                    ]
                  }
                ]
              }
              type: 'If'
            }
          }
          runAfter: {
            Parse_JSON_Select_values: [
              'Succeeded'
            ]
          }
          type: 'Foreach'
        }
        HTTP_GET_Service_Messages: {
          runAfter: {
          }
          type: 'Http'
          inputs: {
            authentication: {
              audience: 'https://graph.microsoft.com'
              identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_IntuneServiceMsg_Identity_name)
              type: 'ManagedServiceIdentity'
            }
            method: 'GET'
            uri: 'https://graph.microsoft.com/v1.0/admin/serviceAnnouncement/issues?$filter=service%20eq%20\'Microsoft%20Intune\''
          }
        }
        Parse_JSON_Select_values: {
          runAfter: {
            Select_values: [
              'Succeeded'
            ]
          }
          type: 'ParseJson'
          inputs: {
            content: '@body(\'Select_values\')'
            schema: {
              items: {
                properties: {
                  Classification: {
                    type: 'string'
                  }
                  ID: {
                    type: 'string'
                  }
                  'Impact Description': {
                    type: 'string'
                  }
                  'Is Resolved': {
                    type: 'boolean'
                  }
                  'Last Modified Time': {
                    type: 'string'
                  }
                  'Start Date Time': {
                    type: 'string'
                  }
                  Status: {
                    type: 'string'
                  }
                  Title: {
                    type: 'string'
                  }
                }
                required: [
                  'Classification'
                  'ID'
                  'Last Modified Time'
                  'Start Date Time'
                  'Status'
                  'Title'
                  'Impact Description'
                  'Is Resolved'
                ]
                type: 'object'
              }
              type: 'array'
            }
          }
        }
        Select_values: {
          runAfter: {
            HTTP_GET_Service_Messages: [
              'Succeeded'
            ]
          }
          type: 'Select'
          inputs: {
            from: '@body(\'HTTP_GET_Service_Messages\')?[\'value\']'
            select: {
              Classification: '@item()?[\'Classification\']'
              ID: '@item()?[\'Id\']'
              'Impact Description': '@item()?[\'impactDescription\']'
              'Is Resolved': '@item()?[\'isResolved\']'
              'Last Modified Time': '@item()?[\'lastModifiedDateTime\']'
              'Start Date Time': '@item()?[\'startDateTime\']'
              Status: '@item()?[\'Status\']'
              Title: '@item()?[\'Title\']'
            }
          }
        }
      }
      outputs: {
      }
    }
    parameters: {
    }
  }
}
