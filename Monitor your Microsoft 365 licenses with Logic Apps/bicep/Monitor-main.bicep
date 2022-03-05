param workflows_Monitor_main_name string
param connections_office365_name string = 'office365'
param resourceLocation string = resourceGroup().location
param userAssignedIdentities_Monitor_Identity_name string = 'Monitor-ManagedIdentity'
param EmailFrom string
param EmailTo string


resource workflows_Monitor_main_name_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflows_Monitor_main_name
  location: resourceLocation
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities/',userAssignedIdentities_Monitor_Identity_name)}': {}
    }
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
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
        For_each_Sku_enabled: {
          foreach: '@body(\'Parse_JSON_GET_all_subscribedSkus\')?[\'value\']'
          actions: {
            Condition: {
              actions: {
                'Send_an_email_from_a_shared_mailbox_(V2)': {
                  runAfter: {}
                  type: 'ApiConnection'
                  inputs: {
                    body: {
                      Body: '<p>Hi,<br>\n<br>\nWe are running out of licenses for<strong> </strong><strong>@{body(\'Parse_JSON_GET_one_Sku_enabled\')?[\'skuPartNumber\']}</strong><strong></strong><br>\nHere is an overview of the consumpted and avialable licenses:<br>\nTotal number of licenses @{body(\'Parse_JSON_GET_one_Sku_enabled\')?[\'prepaidUnits\']?[\'enabled\']}<br>\nTotal number of available licenses: @{sub(body(\'Parse_JSON_GET_one_Sku_enabled\')?[\'prepaidUnits\']?[\'enabled\'],body(\'Parse_JSON_GET_one_Sku_enabled\')?[\'consumedUnits\'])}</p>'
                      Importance: 'High'
                      MailboxAddress: EmailFrom
                      Subject: 'We are running out of licenses for @{body(\'Parse_JSON_GET_one_Sku_enabled\')?[\'skuPartNumber\']}'
                      To: EmailTo
                    }
                    host: {
                      connection: {
                        name: '@parameters(\'$connections\')[\'office365_1\'][\'connectionId\']'
                      }
                    }
                    method: 'post'
                    path: '/v2/SharedMailbox/Mail'
                  }
                }
              }
              runAfter: {
                Parse_JSON_GET_one_Sku_enabled: [
                  'Succeeded'
                ]
              }
              expression: {
                and: [
                  {
                    greater: [
                      '@body(\'Parse_JSON_GET_one_Sku_enabled\')?[\'prepaidUnits\']?[\'enabled\']'
                      0
                    ]
                  }
                  {
                    less: [
                      '@sub(body(\'Parse_JSON_GET_one_Sku_enabled\')?[\'prepaidUnits\']?[\'enabled\'],body(\'Parse_JSON_GET_one_Sku_enabled\')?[\'consumedUnits\'])'
                      10
                    ]
                  }
                ]
              }
              type: 'If'
            }
            HTTP_GET_one_Sku_enabled: {
              runAfter: {}
              type: 'Http'
              inputs: {
                authentication: {
                  audience: 'https://graph.microsoft.com'
                  identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_Monitor_Identity_name)
                  type: 'ManagedServiceIdentity'
                }
                method: 'GET'
                uri: 'https://graph.microsoft.com/v1.0/subscribedSkus/@{items(\'For_each_Sku_enabled\')?[\'id\']}'
              }
            }
            Parse_JSON_GET_one_Sku_enabled: {
              runAfter: {
                HTTP_GET_one_Sku_enabled: [
                  'Succeeded'
                ]
              }
              type: 'ParseJson'
              inputs: {
                content: '@body(\'HTTP_GET_one_Sku_enabled\')'
                schema: {
                  properties: {
                    '@@odata.context': {
                      type: 'string'
                    }
                    appliesTo: {
                      type: 'string'
                    }
                    capabilityStatus: {
                      type: 'string'
                    }
                    consumedUnits: {
                      type: 'integer'
                    }
                    id: {
                      type: 'string'
                    }
                    prepaidUnits: {
                      properties: {
                        enabled: {
                          type: 'integer'
                        }
                        suspended: {
                          type: 'integer'
                        }
                        warning: {
                          type: 'integer'
                        }
                      }
                      type: 'object'
                    }
                    servicePlans: {
                      items: {
                        properties: {
                          appliesTo: {
                            type: 'string'
                          }
                          provisioningStatus: {
                            type: 'string'
                          }
                          servicePlanId: {
                            type: 'string'
                          }
                          servicePlanName: {
                            type: 'string'
                          }
                        }
                        required: [
                          'servicePlanId'
                          'servicePlanName'
                          'provisioningStatus'
                          'appliesTo'
                        ]
                        type: 'object'
                      }
                      type: 'array'
                    }
                    skuId: {
                      type: 'string'
                    }
                    skuPartNumber: {
                      type: 'string'
                    }
                  }
                  type: 'object'
                }
              }
            }
          }
          runAfter: {
            Parse_JSON_GET_all_subscribedSkus: [
              'Succeeded'
            ]
          }
          type: 'Foreach'
        }
        For_each_Sku_warning: {
          foreach: '@body(\'Parse_JSON_GET_all_subscribedSkus\')?[\'value\']'
          actions: {
            Condition_warning_and_consumed: {
              actions: {
                'Send_an_email_from_a_shared_mailbox_(V2)_2': {
                  runAfter: {}
                  type: 'ApiConnection'
                  inputs: {
                    body: {
                      Body: '<p>Hi,<br>\n<br>\nThis license is expired<strong> </strong><strong>@{body(\'Parse_JSON_GET_one_Sku_warning\')?[\'skuPartNumber\']}</strong><strong>,</strong> but the license is still assigned to @{body(\'Parse_JSON_GET_one_Sku_warning\')?[\'consumedUnits\']}users.<br>\n<br>\nPlease extend this license.</p>'
                      Importance: 'High'
                      MailboxAddress: EmailFrom
                      Subject: 'Expired license @{body(\'Parse_JSON_GET_one_Sku_warning\')?[\'skuPartNumber\']} is still in use'
                      To: EmailTo
                    }
                    host: {
                      connection: {
                        name: '@parameters(\'$connections\')[\'office365_2\'][\'connectionId\']'
                      }
                    }
                    method: 'post'
                    path: '/v2/SharedMailbox/Mail'
                  }
                }
              }
              runAfter: {
                Parse_JSON_GET_one_Sku_warning: [
                  'Succeeded'
                ]
              }
              expression: {
                and: [
                  {
                    greater: [
                      '@body(\'Parse_JSON_GET_one_Sku_warning\')?[\'prepaidUnits\']?[\'warning\']'
                      0
                    ]
                  }
                  {
                    greater: [
                      '@body(\'Parse_JSON_GET_one_Sku_warning\')?[\'consumedUnits\']'
                      0
                    ]
                  }
                ]
              }
              type: 'If'
            }
            HTTP_GET_one_Sku_warning: {
              runAfter: {}
              type: 'Http'
              inputs: {
                authentication: {
                  audience: 'https://graph.microsoft.com'
                  identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_Monitor_Identity_name)
                  type: 'ManagedServiceIdentity'
                }
                method: 'GET'
                uri: 'https://graph.microsoft.com/v1.0/subscribedSkus/@{items(\'For_each_Sku_warning\')?[\'id\']}'
              }
            }
            Parse_JSON_GET_one_Sku_warning: {
              runAfter: {
                HTTP_GET_one_Sku_warning: [
                  'Succeeded'
                ]
              }
              type: 'ParseJson'
              inputs: {
                content: '@body(\'HTTP_GET_one_Sku_warning\')'
                schema: {
                  properties: {
                    '@@odata.context': {
                      type: 'string'
                    }
                    appliesTo: {
                      type: 'string'
                    }
                    capabilityStatus: {
                      type: 'string'
                    }
                    consumedUnits: {
                      type: 'integer'
                    }
                    id: {
                      type: 'string'
                    }
                    prepaidUnits: {
                      properties: {
                        enabled: {
                          type: 'integer'
                        }
                        suspended: {
                          type: 'integer'
                        }
                        warning: {
                          type: 'integer'
                        }
                      }
                      type: 'object'
                    }
                    servicePlans: {
                      items: {
                        properties: {
                          appliesTo: {
                            type: 'string'
                          }
                          provisioningStatus: {
                            type: 'string'
                          }
                          servicePlanId: {
                            type: 'string'
                          }
                          servicePlanName: {
                            type: 'string'
                          }
                        }
                        required: [
                          'servicePlanId'
                          'servicePlanName'
                          'provisioningStatus'
                          'appliesTo'
                        ]
                        type: 'object'
                      }
                      type: 'array'
                    }
                    skuId: {
                      type: 'string'
                    }
                    skuPartNumber: {
                      type: 'string'
                    }
                  }
                  type: 'object'
                }
              }
            }
          }
          runAfter: {
            Parse_JSON_GET_all_subscribedSkus: [
              'Succeeded'
            ]
          }
          type: 'Foreach'
        }
        HTTP_GET_all_subscribedSkus: {
          runAfter: {}
          type: 'Http'
          inputs: {
            authentication: {
              audience: 'https://graph.microsoft.com'
              identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_Monitor_Identity_name)
              type: 'ManagedServiceIdentity'
            }
            method: 'GET'
            uri: 'https://graph.microsoft.com/v1.0/subscribedSkus'
          }
        }
        Parse_JSON_GET_all_subscribedSkus: {
          runAfter: {
            HTTP_GET_all_subscribedSkus: [
              'Succeeded'
            ]
          }
          type: 'ParseJson'
          inputs: {
            content: '@body(\'HTTP_GET_all_subscribedSkus\')'
            schema: {
              properties: {
                '@@odata.context': {
                  type: 'string'
                }
                value: {
                  items: {
                    properties: {
                      appliesTo: {
                        type: 'string'
                      }
                      capabilityStatus: {
                        type: 'string'
                      }
                      consumedUnits: {
                        type: 'integer'
                      }
                      id: {
                        type: 'string'
                      }
                      prepaidUnits: {
                        properties: {
                          enabled: {
                            type: 'integer'
                          }
                          suspended: {
                            type: 'integer'
                          }
                          warning: {
                            type: 'integer'
                          }
                        }
                        type: 'object'
                      }
                      servicePlans: {
                        items: {
                          properties: {
                            appliesTo: {
                              type: 'string'
                            }
                            provisioningStatus: {
                              type: 'string'
                            }
                            servicePlanId: {
                              type: 'string'
                            }
                            servicePlanName: {
                              type: 'string'
                            }
                          }
                          required: [
                            'servicePlanId'
                            'servicePlanName'
                            'provisioningStatus'
                            'appliesTo'
                          ]
                          type: 'object'
                        }
                        type: 'array'
                      }
                      skuId: {
                        type: 'string'
                      }
                      skuPartNumber: {
                        type: 'string'
                      }
                    }
                    required: [
                      'capabilityStatus'
                      'consumedUnits'
                      'id'
                      'skuId'
                      'skuPartNumber'
                      'appliesTo'
                      'prepaidUnits'
                      'servicePlans'
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
    parameters: {
      '$connections': {
        value: {
          office365_1: {
            connectionId: resourceId('Microsoft.Web/connections', connections_office365_name)
            connectionName: 'office365'
            id: '${subscription().id}/providers/Microsoft.Web/locations/${resourceLocation}/managedApis/office365'
          }

        }
      }
    }
  }
}
