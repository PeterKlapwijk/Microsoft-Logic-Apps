param workflows_LOBAppsExpiryNotifications_name string
param connections_office365_name string = 'office365'
param resourceLocation string
param userAssignedIdentities_LOBAppExpiryNotifications_Identity_name string = 'LOBAppExpiryNotifications-ManagedIdentity'

resource workflows_LOBAppsExpiryNotificationsv_name_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflows_LOBAppsExpiryNotifications_name
  location: resourceLocation
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities/',userAssignedIdentities_LOBAppExpiryNotifications_Identity_name)}': {}
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
        For_each_iOS_LOB_Apps: {
          foreach: '@body(\'Parse_JSON_GET_iOS_LOB_Apps\')?[\'value\']'
          actions: {
            Condition_iOS_Expiry_Date_30_days: {
              actions: {
                HTTP_POST_Teams_webhook: {
                  runAfter: {
                    'Send_an_email_from_a_shared_mailbox_(V2)': [
                      'Succeeded'
                    ]
                  }
                  type: 'Http'
                  inputs: {
                    body: {
                      text: '**Application name:** @{items(\'For_each_iOS_LOB_Apps\')?[\'displayName\']}\n\n **Expiration date:** @{items(\'For_each_iOS_LOB_Apps\')?[\'expirationDateTime\']}\n\n Please contact the application owner/ developer of the LOB app to supply an updated version of the app.'
                      title: 'iOS LOB App @{items(\'For_each_iOS_LOB_Apps\')?[\'displayName\']} is about to expire!'
                    }
                    headers: {
                      'Content-Type': 'application/json'
                    }
                    method: 'POST'
                    uri: ''
                  }
                }
                'Send_an_email_from_a_shared_mailbox_(V2)': {
                  runAfter: {
                  }
                  type: 'ApiConnection'
                  inputs: {
                    body: {
                      Body: '<p>Dear colleague,<br>\n<br>\nHereby we want to notify you that iOS LOB app @{items(\'For_each_iOS_LOB_Apps\')?[\'displayName\']} is about to expire on @{items(\'For_each_iOS_LOB_Apps\')?[\'expirationDateTime\']}. Please contact the application owner/ developer of the LOB app to supply an updated version of the app.<br>\n<br>\nKind regards,<br>\n<br>\nTeam InTheCloud247</p>'
                      Importance: 'High'
                      MailboxAddress: ''
                      Subject: 'iOS LOB App @{items(\'For_each_iOS_LOB_Apps\')?[\'displayName\']} is about to expire'
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
              runAfter: {
              }
              expression: {
                and: [
                  {
                    less: [
                      '@items(\'For_each_iOS_LOB_Apps\')?[\'expirationDateTime\']'
                      '@addToTime(utcNow(),30,\'day\')'
                    ]
                  }
                ]
              }
              type: 'If'
            }
          }
          runAfter: {
            Parse_JSON_GET_iOS_LOB_Apps: [
              'Succeeded'
            ]
          }
          type: 'Foreach'
        }
        HTTP_GET_iOS_LOB_Apps: {
          runAfter: {
          }
          type: 'Http'
          inputs: {
            authentication: {
              audience: 'https://graph.microsoft.com'
              identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_LOBAppExpiryNotifications_Identity_name)
              type: 'ManagedServiceIdentity'
            }
            method: 'GET'
            uri: 'https://graph.microsoft.com/beta/deviceAppManagement/mobileApps?$filter=(isof(%27microsoft.graph.iosLobApp%27)%20or%20isof(%27microsoft.graph.managedIOSLobApp%27))%20and%20(microsoft.graph.managedApp/appAvailability%20eq%20null%20or%20microsoft.graph.managedApp/appAvailability%20eq%20%27lineOfBusiness%27%20or%20isAssigned%20eq%20true)&$orderby=displayName&'
          }
        }
        Parse_JSON_GET_iOS_LOB_Apps: {
          runAfter: {
            HTTP_GET_iOS_LOB_Apps: [
              'Succeeded'
            ]
          }
          type: 'ParseJson'
          inputs: {
            content: '@body(\'HTTP_GET_iOS_LOB_Apps\')'
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
                      '@@odata.type': {
                        type: 'string'
                      }
                      appAvailability: {
                        type: 'string'
                      }
                      applicableDeviceType: {
                        properties: {
                          iPad: {
                            type: 'boolean'
                          }
                          iPhoneAndIPod: {
                            type: 'boolean'
                          }
                        }
                        type: 'object'
                      }
                      buildNumber: {
                        type: 'string'
                      }
                      bundleId: {
                        type: 'string'
                      }
                      committedContentVersion: {
                      }
                      createdDateTime: {
                        type: 'string'
                      }
                      dependentAppCount: {
                        type: 'integer'
                      }
                      description: {
                        type: 'string'
                      }
                      developer: {
                        type: 'string'
                      }
                      displayName: {
                        type: 'string'
                      }
                      expirationDateTime: {
                        type: 'string'
                      }
                      fileName: {
                        type: 'string'
                      }
                      id: {
                        type: 'string'
                      }
                      identityVersion: {
                        type: 'string'
                      }
                      informationUrl: {
                      }
                      isAssigned: {
                        type: 'boolean'
                      }
                      isFeatured: {
                        type: 'boolean'
                      }
                      largeIcon: {
                      }
                      lastModifiedDateTime: {
                        type: 'string'
                      }
                      minimumSupportedOperatingSystem: {
                        properties: {
                          v10_0: {
                            type: 'boolean'
                          }
                          v11_0: {
                            type: 'boolean'
                          }
                          v12_0: {
                            type: 'boolean'
                          }
                          v13_0: {
                            type: 'boolean'
                          }
                          v14_0: {
                            type: 'boolean'
                          }
                          v15_0: {
                            type: 'boolean'
                          }
                          v16_0: {
                            type: 'boolean'
                          }
                          v8_0: {
                            type: 'boolean'
                          }
                          v9_0: {
                            type: 'boolean'
                          }
                        }
                        type: 'object'
                      }
                      notes: {
                        type: 'string'
                      }
                      owner: {
                        type: 'string'
                      }
                      privacyInformationUrl: {
                        type: [
                          'string'
                          'null'
                        ]
                      }
                      publisher: {
                        type: 'string'
                      }
                      publishingState: {
                        type: 'string'
                      }
                      roleScopeTagIds: {
                        type: 'array'
                      }
                      size: {
                        type: 'integer'
                      }
                      supersededAppCount: {
                        type: 'integer'
                      }
                      supersedingAppCount: {
                        type: 'integer'
                      }
                      uploadState: {
                        type: 'integer'
                      }
                      version: {
                      }
                      versionNumber: {
                        type: 'string'
                      }
                    }
                    required: [
                      '@@odata.type'
                      'id'
                      'displayName'
                      'description'
                      'publisher'
                      'largeIcon'
                      'createdDateTime'
                      'lastModifiedDateTime'
                      'isFeatured'
                      'privacyInformationUrl'
                      'informationUrl'
                      'owner'
                      'developer'
                      'notes'
                      'uploadState'
                      'publishingState'
                      'isAssigned'
                      'roleScopeTagIds'
                      'dependentAppCount'
                      'supersedingAppCount'
                      'supersededAppCount'
                      'appAvailability'
                      'version'
                      'committedContentVersion'
                      'fileName'
                      'size'
                      'bundleId'
                      'expirationDateTime'
                      'versionNumber'
                      'buildNumber'
                      'identityVersion'
                      'applicableDeviceType'
                      'minimumSupportedOperatingSystem'
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
