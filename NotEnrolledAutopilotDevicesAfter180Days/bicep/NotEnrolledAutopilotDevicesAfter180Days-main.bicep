param workflows_NotEnrolledAutopilotDevicesAfter180Days_name string
param connections_excelonlinebusiness_name string = 'excelonlinebusiness'
param connections_office365_name string = 'office365'
param connections_SharePointOnline_name string = 'SharePointOnline'
param userAssignedIdentities_Autopilot180days_Identity_name string = 'Autopilot180days-ManagedIdentity'
param resourceLocation string

resource workflows_NotEnrolledAutopilotDevicesAfter180Days_name_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflows_NotEnrolledAutopilotDevicesAfter180Days_name
  location: resourceLocation
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities/',userAssignedIdentities_Autopilot180days_Identity_name)}': {}
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
        Compose_Excel_file: {
          runAfter: {
          }
          type: 'Compose'
          inputs: {
            '$content': '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'
            '$content-type': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
          }
        }
        Create_file: {
          runAfter: {
            Compose_Excel_file: [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
          inputs: {
            body: '@outputs(\'Compose_Excel_file\')'
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'sharepointonline\'][\'connectionId\']'
              }
            }
            method: 'post'
            path: '/datasets/@{encodeURIComponent(encodeURIComponent(\'\'))}/files'
            queries: {
              folderPath: '/'
              name: 'AutopilotNotEnrolledSNs@{formatDateTime(utcNow(), \'yyyy-MM-dd-HH-mm\')}.xlsx'
              queryParametersSingleEncoded: true
            }
          }
          runtimeConfiguration: {
            contentTransfer: {
              transferMode: 'Chunked'
            }
          }
        }
        Create_table: {
          runAfter: {
            Create_file: [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
          inputs: {
            body: {
              ColumnsNames: 'serialNumber,displayName,enrollmentState,groupTag,manufacturer,model,createdDateTime'
              Range: 'A1:F1'
              TableName: 'SerialNumbers'
            }
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'excelonlinebusiness\'][\'connectionId\']'
              }
            }
            method: 'post'
            path: '/drives/@{encodeURIComponent(\'b!03bMWm1Z50up7V3S5PdGiEf4m1Lr4uhPnNqEYLk9Umq9Zot084gERI2gxgrytSuA\')}/files/@{encodeURIComponent(encodeURIComponent(body(\'Create_file\')?[\'Id\']))}/tables'
            queries: {
              source: 'groups/7ea748de-663e-430e-88b7-52c7b7b9455b'
            }
          }
        }
        Delay: {
          runAfter: {
            For_each_filtered_deviceId: [
              'Succeeded'
            ]
          }
          type: 'Wait'
          inputs: {
            interval: {
              count: 2
              unit: 'Minute'
            }
          }
        }
        Filter_array_enrollmentState: {
          runAfter: {
            Parse_JSON_GET_windowsAutopilotDeviceIdentities: [
              'Succeeded'
            ]
          }
          type: 'Query'
          inputs: {
            from: '@body(\'Parse_JSON_GET_windowsAutopilotDeviceIdentities\')?[\'value\']'
            where: '@not(equals(item()?[\'enrollmentState\'], \'enrolled\'))'
          }
        }
        For_each_filtered_deviceId: {
          foreach: '@body(\'Filter_array_enrollmentState\')'
          actions: {
            For_each_deviceId: {
              foreach: '@body(\'Parse_JSON_GET_Devices\')?[\'value\']'
              actions: {
                Condition_createdDateTime: {
                  actions: {
                    Add_a_row_into_a_table: {
                      runAfter: {
                        Compose_Row_for_each_serial_number: [
                          'Succeeded'
                        ]
                      }
                      type: 'ApiConnection'
                      inputs: {
                        body: '@outputs(\'Compose_Row_for_each_serial_number\')'
                        host: {
                          connection: {
                            name: '@parameters(\'$connections\')[\'excelonlinebusiness\'][\'connectionId\']'
                          }
                        }
                        method: 'post'
                        path: '/codeless/v1.2/drives/@{encodeURIComponent(\'\')}/items/@{encodeURIComponent(encodeURIComponent(body(\'Create_file\')?[\'Id\']))}/workbook/tables/@{encodeURIComponent(\'SerialNumbers\')}/rows'
                        queries: {
                          source: 'groups/7ea748de-663e-430e-88b7-52c7b7b9455b'
                        }
                      }
                    }
                    Compose_Row_for_each_serial_number: {
                      runAfter: {
                      }
                      type: 'Compose'
                      inputs: {
                        createdDateTime: '@items(\'For_each_deviceId\')?[\'createdDateTime\']'
                        displayName: '@items(\'For_each_deviceId\')?[\'displayName\']'
                        enrollmentState: '@items(\'For_each_filtered_deviceId\')?[\'enrollmentState\']'
                        groupTag: '@items(\'For_each_filtered_deviceId\')?[\'groupTag\']'
                        manufacturer: '@items(\'For_each_filtered_deviceId\')?[\'manufacturer\']'
                        model: '@items(\'For_each_filtered_deviceId\')?[\'model\']'
                        serialNumber: '@items(\'For_each_filtered_deviceId\')?[\'serialNumber\']'
                      }
                    }
                  }
                  runAfter: {
                  }
                  expression: {
                    and: [
                      {
                        less: [
                          '@items(\'For_each_deviceId\')?[\'createdDateTime\']'
                          '@adddays(utcNow(\'yyyy-MM-ddTHH:mm:ssZ\'),-165)'
                        ]
                      }
                      {
                        equals: [
                          '@items(\'For_each_filtered_deviceId\')?[\'serialNumber\']'
                          '@items(\'For_each_deviceId\')?[\'displayName\']'
                        ]
                      }
                    ]
                  }
                  type: 'If'
                }
              }
              runAfter: {
                Parse_JSON_GET_Devices: [
                  'Succeeded'
                ]
              }
              type: 'Foreach'
            }
            HTTP_GET_Devices: {
              runAfter: {
              }
              type: 'Http'
              inputs: {
                authentication: {
                  audience: 'https://graph.microsoft.com'
                  identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_Autopilot180days_Identity_name)
                  type: 'ManagedServiceIdentity'
                }
                method: 'GET'
                uri: 'https://graph.microsoft.com/v1.0/devices?$filter=(deviceId%20eq%20\'@{items(\'For_each_filtered_deviceId\')?[\'azureActiveDirectoryDeviceId\']}\')'
              }
            }
            Parse_JSON_GET_Devices: {
              runAfter: {
                HTTP_GET_Devices: [
                  'Succeeded'
                ]
              }
              type: 'ParseJson'
              inputs: {
                content: '@body(\'HTTP_GET_Devices\')'
                schema: {
                  properties: {
                    '@@odata.context': {
                      type: 'string'
                    }
                    value: {
                      items: {
                        properties: {
                          accountEnabled: {
                            type: 'boolean'
                          }
                          alternativeSecurityIds: {
                            items: {
                              properties: {
                                identityProvider: {
                                }
                                key: {
                                  type: 'string'
                                }
                                type: {
                                  type: 'integer'
                                }
                              }
                              required: [
                                'type'
                                'identityProvider'
                                'key'
                              ]
                              type: 'object'
                            }
                            type: 'array'
                          }
                          approximateLastSignInDateTime: {
                            type: 'string'
                          }
                          complianceExpirationDateTime: {
                          }
                          createdDateTime: {
                            type: 'string'
                          }
                          deletedDateTime: {
                          }
                          deviceCategory: {
                          }
                          deviceId: {
                            type: 'string'
                          }
                          deviceMetadata: {
                          }
                          deviceOwnership: {
                            type: [
                              'string'
                              'null'
                            ]
                          }
                          deviceVersion: {
                            type: 'integer'
                          }
                          displayName: {
                            type: 'string'
                          }
                          domainName: {
                          }
                          enrollmentProfileName: {
                            type: [
                              'string'
                              'null'
                            ]
                          }
                          enrollmentType: {
                            type: [
                              'string'
                              'null'
                            ]
                          }
                          extensionAttributes: {
                            properties: {
                              extensionAttribute1: {
                              }
                              extensionAttribute10: {
                              }
                              extensionAttribute11: {
                              }
                              extensionAttribute12: {
                              }
                              extensionAttribute13: {
                              }
                              extensionAttribute14: {
                              }
                              extensionAttribute15: {
                              }
                              extensionAttribute2: {
                              }
                              extensionAttribute3: {
                              }
                              extensionAttribute4: {
                              }
                              extensionAttribute5: {
                              }
                              extensionAttribute6: {
                              }
                              extensionAttribute7: {
                              }
                              extensionAttribute8: {
                              }
                              extensionAttribute9: {
                              }
                            }
                            type: 'object'
                          }
                          externalSourceName: {
                          }
                          id: {
                            type: 'string'
                          }
                          isCompliant: {
                            type: [
                              'boolean'
                              'null'
                            ]
                          }
                          isManaged: {
                            type: [
                              'boolean'
                              'null'
                            ]
                          }
                          isRooted: {
                            type: [
                              'boolean'
                              'null'
                            ]
                          }
                          managementType: {
                            type: [
                              'string'
                              'null'
                            ]
                          }
                          manufacturer: {
                            type: [
                              'string'
                              'null'
                            ]
                          }
                          mdmAppId: {
                            type: [
                              'string'
                              'null'
                            ]
                          }
                          model: {
                            type: [
                              'string'
                              'null'
                            ]
                          }
                          onPremisesLastSyncDateTime: {
                          }
                          onPremisesSyncEnabled: {
                          }
                          operatingSystem: {
                            type: 'string'
                          }
                          operatingSystemVersion: {
                            type: 'string'
                          }
                          physicalIds: {
                            items: {
                              type: 'string'
                            }
                            type: 'array'
                          }
                          profileType: {
                            type: 'string'
                          }
                          registrationDateTime: {
                            type: 'string'
                          }
                          sourceType: {
                          }
                          systemLabels: {
                            type: 'array'
                          }
                          trustType: {
                            type: 'string'
                          }
                        }
                        required: [
                          'id'
                          'deletedDateTime'
                          'accountEnabled'
                          'approximateLastSignInDateTime'
                          'complianceExpirationDateTime'
                          'createdDateTime'
                          'deviceCategory'
                          'deviceId'
                          'deviceMetadata'
                          'deviceOwnership'
                          'deviceVersion'
                          'displayName'
                          'domainName'
                          'enrollmentProfileName'
                          'enrollmentType'
                          'externalSourceName'
                          'isCompliant'
                          'isManaged'
                          'isRooted'
                          'managementType'
                          'manufacturer'
                          'mdmAppId'
                          'model'
                          'onPremisesLastSyncDateTime'
                          'onPremisesSyncEnabled'
                          'operatingSystem'
                          'operatingSystemVersion'
                          'physicalIds'
                          'profileType'
                          'registrationDateTime'
                          'sourceType'
                          'systemLabels'
                          'trustType'
                          'extensionAttributes'
                          'alternativeSecurityIds'
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
            Filter_array_enrollmentState: [
              'Succeeded'
            ]
          }
          type: 'Foreach'
        }
        Get_file_content: {
          runAfter: {
            Delay: [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'sharepointonline\'][\'connectionId\']'
              }
            }
            method: 'get'
            path: '/datasets/@{encodeURIComponent(encodeURIComponent(\'\'))}/files/@{encodeURIComponent(body(\'Create_file\')?[\'Id\'])}/content'
            queries: {
              inferContentType: true
            }
          }
        }
        HTTP_GET_windowsAutopilotDeviceIdentities: {
          runAfter: {
            Create_table: [
              'Succeeded'
            ]
          }
          type: 'Http'
          inputs: {
            authentication: {
              audience: 'https://graph.microsoft.com'
              identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_Autopilot180days_Identity_name)
              type: 'ManagedServiceIdentity'
            }
            method: 'GET'
            uri: 'https://graph.microsoft.com/v1.0/deviceManagement/windowsAutopilotDeviceIdentities'
          }
        }
        Parse_JSON_GET_windowsAutopilotDeviceIdentities: {
          runAfter: {
            HTTP_GET_windowsAutopilotDeviceIdentities: [
              'Succeeded'
            ]
          }
          type: 'ParseJson'
          inputs: {
            content: '@body(\'HTTP_GET_windowsAutopilotDeviceIdentities\')'
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
                      addressableUserName: {
                        type: 'string'
                      }
                      azureActiveDirectoryDeviceId: {
                        type: 'string'
                      }
                      displayName: {
                        type: 'string'
                      }
                      enrollmentState: {
                        type: 'string'
                      }
                      groupTag: {
                        type: 'string'
                      }
                      id: {
                        type: 'string'
                      }
                      lastContactedDateTime: {
                        type: 'string'
                      }
                      managedDeviceId: {
                        type: 'string'
                      }
                      manufacturer: {
                        type: 'string'
                      }
                      model: {
                        type: 'string'
                      }
                      productKey: {
                        type: 'string'
                      }
                      purchaseOrderIdentifier: {
                        type: 'string'
                      }
                      resourceName: {
                        type: 'string'
                      }
                      serialNumber: {
                        type: 'string'
                      }
                      skuNumber: {
                        type: 'string'
                      }
                      systemFamily: {
                        type: 'string'
                      }
                      userPrincipalName: {
                        type: 'string'
                      }
                    }
                    required: [
                      'id'
                      'groupTag'
                      'purchaseOrderIdentifier'
                      'serialNumber'
                      'productKey'
                      'manufacturer'
                      'model'
                      'enrollmentState'
                      'lastContactedDateTime'
                      'addressableUserName'
                      'userPrincipalName'
                      'resourceName'
                      'skuNumber'
                      'systemFamily'
                      'azureActiveDirectoryDeviceId'
                      'managedDeviceId'
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
        'Send_an_email_from_a_shared_mailbox_(V2)': {
          runAfter: {
            Get_file_content: [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
          inputs: {
            body: {
              Attachments: [
                {
                  ContentBytes: '@{base64(body(\'Get_file_content\'))}'
                  Name: '@body(\'Create_file\')?[\'Name\']'
                }
              ]
              Body: '<p>Hello IT Super Hero,<br>\n<br>\nAttached you\'ll find an overview of Windows Autopilot registered objects which are <strong>registered 165 days ago</strong>. &nbsp;If the device is registered and not enrolled after <strong>180 days</strong>, you\'ll need to re-register the device to complete a successful deployment.<br>\nPlease take the needed action.</p>'
              Importance: 'High'
              MailboxAddress: ''
              Subject: 'Action needed: Autopilot devices overview registered 165 days ago'
              To: ''
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
      outputs: {
      }
    }
    parameters: {
      '$connections': {
        value: {
          excelonlinebusiness: {
            connectionId: resourceId('Microsoft.Web/connections', connections_excelonlinebusiness_name)
            connectionName: 'excelonlinebusiness'
            id: '${subscription().id}/providers/Microsoft.Web/locations/${resourceLocation}/managedApis/excelonlinebusiness'
          }
          office365: {
            connectionId: resourceId('Microsoft.Web/connections', connections_office365_name)
            connectionName: 'office365'
            id: '${subscription().id}/providers/Microsoft.Web/locations/${resourceLocation}/managedApis/office365'
          }
          sharepointonline: {
            connectionId: resourceId('Microsoft.Web/connections', connections_SharePointOnline_name)
            connectionName: 'SharePointOnline'
            id: '${subscription().id}/providers/Microsoft.Web/locations/${resourceLocation}/managedApis/SharePointOnline'
          }
        }
      }
    }
  }
}
