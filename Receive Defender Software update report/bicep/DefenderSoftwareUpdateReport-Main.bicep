param workflows_DefenderforEndpointSoftwareUpdateReport_name string
param connections_office365_name string = 'office365'
param resourceLocation string 
param userAssignedIdentities_DefenderforEndpointReporting_ManagedIdentity_name string = 'DefenderforEndpointReporting-ManagedIdentity'

resource workflows_DefenderforEndpointSoftwareUpdateReport_name_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflows_DefenderforEndpointSoftwareUpdateReport_name
  location: resourceLocation
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities/',userAssignedIdentities_DefenderforEndpointReporting_ManagedIdentity_name)}': {}
    }
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {
          }
          type: 'Object'
        }
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
        Filter_array_healthstatus_active: {
          runAfter: {
            Parse_JSON_Get_Machines_findbytag: [
              'Succeeded'
            ]
          }
          type: 'Query'
          inputs: {
            from: '@body(\'Parse_JSON_Get_Machines_findbytag\')?[\'value\']'
            where: '@equals(item()?[\'healthStatus\'], \'Active\')'
          }
        }
        For_each__active_Machine: {
          foreach: '@body(\'Filter_array_healthstatus_active\')'
          actions: {
            Condition_recommendations_empty: {
              actions: {
                For_each_objectID: {
                  foreach: '@body(\'Parse_JSON_GET_AAD_Device_on_deviceid\')?[\'value\']'
                  actions: {
                    Create_CSV_table: {
                      runAfter: {
                        Parse_JSON_GET_registeredOwners: [
                          'Succeeded'
                        ]
                      }
                      type: 'Table'
                      inputs: {
                        format: 'CSV'
                        from: '@body(\'Select_recommendations\')'
                      }
                    }
                    For_each_registeredOwner: {
                      foreach: '@body(\'Parse_JSON_GET_registeredOwners\')?[\'value\']'
                      actions: {
                        'Send_an_email_from_a_shared_mailbox_(V2)': {
                          runAfter: {
                          }
                          type: 'ApiConnection'
                          inputs: {
                            body: {
                              Attachments: [
                                {
                                  ContentBytes: '@{base64(body(\'Create_CSV_table\'))}'
                                  Name: 'SoftwareRecommendations.csv'
                                }
                              ]
                              Body: '<p>Hello @{items(\'For_each_registeredOwner\')?[\'displayName\']},<br>\n<br>\n<br>\nAttached you will find an over view of the software recommendations for your device @{items(\'For_each_objectID\')?[\'displayName\']}. Please update the mentioned software as soon as possible.<br>\n<br>\nKind regards,<br>\n<br>\nIn The Cloud 24-7</p>'
                              Importance: 'Normal'
                              MailboxAddress: ''
                              Subject: 'Software recommendations for device @{items(\'For_each_objectID\')?[\'displayName\']}'
                              To: '@items(\'For_each_registeredOwner\')?[\'mail\']'
                            }
                            host: {
                              connection: {
                                name: '@parameters(\'$connections\')[\'office365\'][\'connectionId\']'
                              }
                            }
                            method: 'post'
                            path: '/v2/SharedMailbox/Mail'
                          }
                        }
                      }
                      runAfter: {
                        Create_CSV_table: [
                          'Succeeded'
                        ]
                      }
                      type: 'Foreach'
                    }
                    HTTP_GET_registeredOwners: {
                      runAfter: {
                      }
                      type: 'Http'
                      inputs: {
                        authentication: {
                          audience: 'https://graph.microsoft.com'
                          identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_DefenderforEndpointReporting_ManagedIdentity_name)
                          type: 'ManagedServiceIdentity'
                        }
                        method: 'GET'
                        uri: 'https://graph.microsoft.com/v1.0/devices/@{items(\'For_each_objectID\')?[\'id\']}/registeredOwners?$select=id,displayName,userPrincipalName,mail'
                      }
                    }
                    Parse_JSON_GET_registeredOwners: {
                      runAfter: {
                        HTTP_GET_registeredOwners: [
                          'Succeeded'
                        ]
                      }
                      type: 'ParseJson'
                      inputs: {
                        content: '@body(\'HTTP_GET_registeredOwners\')'
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
                                  displayName: {
                                    type: 'string'
                                  }
                                  id: {
                                    type: 'string'
                                  }
                                  mail: {
                                    type: 'string'
                                  }
                                  userPrincipalName: {
                                    type: 'string'
                                  }
                                }
                                required: [
                                  '@@odata.type'
                                  'id'
                                  'displayName'
                                  'userPrincipalName'
                                  'mail'
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
                  runAfter: {
                    Parse_JSON_GET_AAD_Device_on_deviceid: [
                      'Succeeded'
                    ]
                  }
                  type: 'Foreach'
                }
                HTTP_GET_AAD_Device_on_deviceid: {
                  runAfter: {
                  }
                  type: 'Http'
                  inputs: {
                    authentication: {
                      audience: 'https://graph.microsoft.com'
                      identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_DefenderforEndpointReporting_ManagedIdentity_name)
                      type: 'ManagedServiceIdentity'
                    }
                    method: 'GET'
                    uri: 'https://graph.microsoft.com/v1.0/devices?$filter=(deviceId%20eq%20\'@{items(\'For_each__active_Machine\')?[\'aadDeviceId\']}\')&$select=id,deviceId,displayName'
                  }
                }
                Parse_JSON_GET_AAD_Device_on_deviceid: {
                  runAfter: {
                    HTTP_GET_AAD_Device_on_deviceid: [
                      'Succeeded'
                    ]
                  }
                  type: 'ParseJson'
                  inputs: {
                    content: '@body(\'HTTP_GET_AAD_Device_on_deviceid\')'
                    schema: {
                      properties: {
                        '@@odata.context': {
                          type: 'string'
                        }
                        value: {
                          items: {
                            properties: {
                              deviceId: {
                                type: 'string'
                              }
                              displayName: {
                                type: 'string'
                              }
                              id: {
                                type: 'string'
                              }
                            }
                            required: [
                              'id'
                              'deviceId'
                              'displayName'
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
              runAfter: {
                Select_recommendations: [
                  'Succeeded'
                ]
              }
              expression: {
                and: [
                  {
                    equals: [
                      '@empty(outputs(\'Select_recommendations\')?[\'body\'])'
                      false
                    ]
                  }
                ]
              }
              type: 'If'
            }
            HTTP_GET_recommendations: {
              runAfter: {
              }
              type: 'Http'
              inputs: {
                authentication: {
                  audience: 'https://api.securitycenter.microsoft.com'
                  identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_DefenderforEndpointReporting_ManagedIdentity_name)
                  type: 'ManagedServiceIdentity'
                }
                method: 'GET'
                uri: 'https://api.securitycenter.microsoft.com/api/machines/@{items(\'For_each__active_Machine\')?[\'id\']}/recommendations?$filter=(remediationType%20eq%20\'Update\')'
              }
            }
            Select_recommendations: {
              runAfter: {
                HTTP_GET_recommendations: [
                  'Succeeded'
                ]
              }
              type: 'Select'
              inputs: {
                from: '@body(\'HTTP_GET_recommendations\')?[\'value\']'
                select: {
                  recommendationName: '@item()?[\'recommendationName\']'
                  recommendedVersion: '@item()?[\'recommendedVersion\']'
                  relatedComponent: '@item()?[\'relatedComponent\']'
                  vendor: '@item()?[\'vendor\']'
                }
              }
            }
          }
          runAfter: {
            Filter_array_healthstatus_active: [
              'Succeeded'
            ]
          }
          type: 'Foreach'
        }
        HTTP_Get_Machines_findbytag: {
          runAfter: {
          }
          type: 'Http'
          inputs: {
            authentication: {
              audience: 'https://api.securitycenter.microsoft.com'
              identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_DefenderforEndpointReporting_ManagedIdentity_name)
              type: 'ManagedServiceIdentity'
            }
            method: 'GET'
            uri: 'https://api.securitycenter.microsoft.com/api/machines/findbytag?tag=DevComputer&$select=id,computerDnsName,osPlatform,healthStatus,aadDeviceId'
          }
        }
        Parse_JSON_Get_Machines_findbytag: {
          runAfter: {
            HTTP_Get_Machines_findbytag: [
              'Succeeded'
            ]
          }
          type: 'ParseJson'
          inputs: {
            content: '@body(\'HTTP_Get_Machines_findbytag\')'
            schema: {
              properties: {
                '@@odata.context': {
                  type: 'string'
                }
                value: {
                  items: {
                    properties: {
                      aadDeviceId: {
                        type: 'string'
                      }
                      computerDnsName: {
                        type: 'string'
                      }
                      healthStatus: {
                        type: 'string'
                      }
                      id: {
                        type: 'string'
                      }
                      osPlatform: {
                        type: 'string'
                      }
                    }
                    required: [
                      'id'
                      'computerDnsName'
                      'osPlatform'
                      'healthStatus'
                      'aadDeviceId'
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
      '$connections': {
        value: {
          office365: {
            connectionId: resourceId('Microsoft.Web/connections', connections_office365_name)
            connectionName: 'office365'
            id: '${subscription().id}/providers/Microsoft.Web/locations/${resourceLocation}/managedApis/office365'
          }

        }
      }
    }
  }
}
