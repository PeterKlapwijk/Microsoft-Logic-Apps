param connections_office365_name string = 'office365'
param resourceLocation string 
param ResourceGroupName string


resource connections_office365_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_office365_name
  location: resourceLocation
  properties: {
    displayName: 'Office 365'
    statuses: [
      {
        status: 'Connected'
      }
    ]
    customParameterValues: {}
    nonSecretParameterValues: {}
    createdTime: '3/5/2022 12:48:50 PM'
    changedTime: '3/5/2022 12:48:58 PM'
    api: {
      name: connections_office365_name
      displayName: 'Office 365 Outlook'
      description: 'Microsoft Office 365 is a cloud-based service that is designed to help meet your organization\'s needs for robust security, reliability, and user productivity.'
      iconUri: 'https://connectoricons-prod.azureedge.net/releases/v1.0.1538/1.0.1538.2621/${connections_office365_name}/icon.png'
      brandColor: '#0078D4'
      id: '${subscription().id}/providers/Microsoft.Web/locations/westeurope/managedApis/${connections_office365_name}'
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: '${subscription().id}/resourceGroups/${ResourceGroupName}/providers/Microsoft.Web/connections/${connections_office365_name}/extensions/proxy/testconnection?api-version=2016-06-01'
        method: 'get'
      }

    ]
  }
}
