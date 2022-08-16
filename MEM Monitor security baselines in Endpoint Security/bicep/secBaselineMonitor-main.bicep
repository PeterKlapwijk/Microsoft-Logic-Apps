param workflows_MonitorSecurityBaselinesEndpointSecurity_name string
param userAssignedIdentities_SecBaselineMonitor_Identity_name string = 'SecBaselineMonitor-ManagedIdentity'
param resourceLocation string 

resource workflows_MonitorSecurityBaselinesEndpointSecurity_name_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflows_MonitorSecurityBaselinesEndpointSecurity_name
  location: resourceLocation
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities/',userAssignedIdentities_SecBaselineMonitor_Identity_name)}': {}
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
            frequency: 'Week'
            interval: 1
          }
          evaluatedRecurrence: {
            frequency: 'Week'
            interval: 1
          }
          type: 'Recurrence'
        }
      }
      actions: {
        For_each_Security_Baseline: {
          foreach: '@body(\'Parse_JSON_GET_Template_Security_Baseline\')?[\'value\']'
          actions: {
            Condition_Security_Baseline: {
              actions: {
                HTTP_POST_Teams_webhook_new_Security_Baseline: {
                  runAfter: {
                  }
                  type: 'Http'
                  inputs: {
                    body: {
                      text: 'A new Security Baseline is published in In Microsoft Endpoint Management admin center. Please review the baseline and if applicable publish the new baseline. \n\n **Display name:** @{items(\'For_each_Security_Baseline\')?[\'displayName\']} \n\n **New version:** @{items(\'For_each_Security_Baseline\')?[\'versionInfo\']} \n\n **Published Date Time:** @{items(\'For_each_Security_Baseline\')?[\'publishedDateTime\']} '
                      title: 'New baseline: @{items(\'For_each_Security_Baseline\')?[\'displayName\']}'
                    }
                    method: 'POST'
                    uri: ''
                  }
                }
              }
              runAfter: {
              }
              expression: {
                and: [
                  {
                    greater: [
                      '@items(\'For_each_Security_Baseline\')?[\'intentCount\']'
                      0
                    ]
                  }
                  {
                    greater: [
                      '@items(\'For_each_Security_Baseline\')?[\'publishedDateTime\']'
                      '@adddays(utcNow(\'yyyy-MM-ddTHH:mm:ssZ\'),-7)'
                    ]
                  }
                ]
              }
              type: 'If'
            }
          }
          runAfter: {
            Parse_JSON_GET_Template_Security_Baseline: [
              'Succeeded'
            ]
          }
          type: 'Foreach'
        }
        For_each_Security_Baseline_profile: {
          foreach: '@body(\'Parse_JSON_GET_Security_Baseline_profiles\')?[\'value\']'
          actions: {
            Condition_Security_Baseline_profile: {
              actions: {
                HTTP_POST_Teams_webhook_unassigned_Security_Baseline_profile: {
                  runAfter: {
                  }
                  type: 'Http'
                  inputs: {
                    body: {
                      text: 'In Microsoft Endpoint Management admin center a Security Baselin profile is not assigned to any group and seems not in use anymore. Please review this and clean-up the role if applicabel. \n\n **Display name:** @{items(\'For_each_Security_Baseline_profile\')?[\'displayName\']} \n\n **Last Modified Date Time:** @{items(\'For_each_Security_Baseline_profile\')?[\'lastModifiedDateTime\']} '
                      title: 'Security Baseline profile not in use: @{items(\'For_each_Security_Baseline_profile\')?[\'displayName\']}'
                    }
                    method: 'POST'
                    uri: ''
                  }
                }
              }
              runAfter: {
              }
              expression: {
                and: [
                  {
                    equals: [
                      '@items(\'For_each_Security_Baseline_profile\')?[\'isAssigned\']'
                      false
                    ]
                  }
                ]
              }
              type: 'If'
            }
          }
          runAfter: {
            Parse_JSON_GET_Security_Baseline_profiles: [
              'Succeeded'
            ]
          }
          type: 'Foreach'
        }
        HTTP_GET_Security_Baseline_profiles: {
          runAfter: {
          }
          type: 'Http'
          inputs: {
            authentication: {
              audience: 'https://graph.microsoft.com'
              identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_SecBaselineMonitor_Identity_name)
              type: 'ManagedServiceIdentity'
            }
            method: 'GET'
            uri: 'https://graph.microsoft.com/beta/deviceManagement/intents?$filter=contains(displayName,\'baseline\')%20or%20contains(displayName,\'Baseline\')'
          }
        }
        HTTP_GET_Template_Security_Baseline: {
          runAfter: {
          }
          type: 'Http'
          inputs: {
            authentication: {
              audience: 'https://graph.microsoft.com'
              identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_SecBaselineMonitor_Identity_name)
              type: 'ManagedServiceIdentity'
            }
            method: 'GET'
            uri: 'https://graph.microsoft.com/beta/deviceManagement/templates?$filter=(templateType%20eq%20\'securityBaseline\')%20or%20(templateType%20eq%20\'advancedThreatProtectionSecurityBaseline\')%20or%20(templateType%20eq%20\'microsoftEdgeSecurityBaseline\')%20or%20(templateType%20eq%20\'cloudPC\')'
          }
        }
        Parse_JSON_GET_Security_Baseline_profiles: {
          runAfter: {
            HTTP_GET_Security_Baseline_profiles: [
              'Succeeded'
            ]
          }
          type: 'ParseJson'
          inputs: {
            content: '@body(\'HTTP_GET_Security_Baseline_profiles\')'
            schema: {
              properties: {
                '@@odata.context': {
                  type: 'string'
                }
                value: {
                  items: {
                    properties: {
                      description: {
                        type: 'string'
                      }
                      displayName: {
                        type: 'string'
                      }
                      id: {
                        type: 'string'
                      }
                      isAssigned: {
                        type: 'boolean'
                      }
                      lastModifiedDateTime: {
                        type: 'string'
                      }
                      roleScopeTagIds: {
                        items: {
                          type: 'string'
                        }
                        type: 'array'
                      }
                      templateId: {
                        type: 'string'
                      }
                    }
                    required: [
                      'id'
                      'displayName'
                      'description'
                      'isAssigned'
                      'lastModifiedDateTime'
                      'templateId'
                      'roleScopeTagIds'
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
        Parse_JSON_GET_Template_Security_Baseline: {
          runAfter: {
            HTTP_GET_Template_Security_Baseline: [
              'Succeeded'
            ]
          }
          type: 'ParseJson'
          inputs: {
            content: '@body(\'HTTP_GET_Template_Security_Baseline\')'
            schema: {
              properties: {
                '@@odata.context': {
                  type: 'string'
                }
                value: {
                  items: {
                    properties: {
                      '@@odata.type': {
                        type: 'string'
                      }
                      description: {
                        type: 'string'
                      }
                      displayName: {
                        type: 'string'
                      }
                      id: {
                        type: 'string'
                      }
                      intentCount: {
                        type: 'integer'
                      }
                      isDeprecated: {
                        type: 'boolean'
                      }
                      platformType: {
                        type: 'string'
                      }
                      publishedDateTime: {
                        type: 'string'
                      }
                      templateSubtype: {
                        type: 'string'
                      }
                      templateType: {
                        type: 'string'
                      }
                      versionInfo: {
                        type: 'string'
                      }
                    }
                    required: [
                      '@@odata.type'
                      'id'
                      'displayName'
                      'description'
                      'versionInfo'
                      'isDeprecated'
                      'intentCount'
                      'templateType'
                      'platformType'
                      'templateSubtype'
                      'publishedDateTime'
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
      outputs: {
      }
    }
    parameters: {
    }
  }
}
