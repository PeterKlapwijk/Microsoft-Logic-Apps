param connections_SharePointOnline_name string = 'SharePointOnline'
param connections_office365_name string = 'office365'
param connections_excelonlinebusiness_name string = 'excelonlinebusiness'
param resourceLocation string 
param ResourceGroupName string


resource connections_SharePointOnline_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_SharePointOnline_name
  location: resourceLocation
  properties: {
    displayName: 'SharePoint'
    statuses: [
      {
        status: 'Connected'
      }
    ]
    customParameterValues: {}
    nonSecretParameterValues: {}
    createdTime: '2022-07-24T16:35:31.6713561Z'
    changedTime: '2022-07-26T11:35:40.9837388Z'
    api: {
      name: connections_SharePointOnline_name
      displayName: 'SharePoint'
      description: 'SharePoint helps organizations share and collaborate with colleagues, partners, and customers. You can connect to SharePoint Online or to an on-premises SharePoint 2013 or 2016 farm using the On-Premises Data Gateway to manage documents and list items.'
      iconUri: 'https://connectoricons-prod.azureedge.net/releases/v1.0.1538/1.0.1538.2621/${connections_SharePointOnline_name}/icon.png'
      brandColor: '#036C70'
      id: '${subscription().id}/providers/Microsoft.Web/locations/${resourceLocation}/managedApis/${connections_SharePointOnline_name}'
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: '${subscription().id}/resourceGroups/${ResourceGroupName}/providers/Microsoft.Web/connections/${connections_SharePointOnline_name}/extensions/proxy/testconnection?api-version=2016-06-01'
        method: 'get'
      }

    ]
  }
}

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
    createdTime: '2022-07-24T16:35:31.6713561Z'
    changedTime: '2022-07-26T11:35:40.9837388Z'
    api: {
      name: connections_office365_name
      displayName: 'Office 365 Outlook'
      description: 'Microsoft Office 365 is a cloud-based service that is designed to help meet your organization\'s needs for robust security, reliability, and user productivity.'
      iconUri: 'https://connectoricons-prod.azureedge.net/releases/v1.0.1538/1.0.1538.2621/${connections_office365_name}/icon.png'
      brandColor: '#0078D4'
      id: '${subscription().id}/providers/Microsoft.Web/locations/${resourceLocation}/managedApis/${connections_office365_name}'
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

resource connections_excelonlinebusiness_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_excelonlinebusiness_name
  location: resourceLocation
  properties: {
    displayName: 'excelonlinebusiness'
    statuses: [
      {
        status: 'Connected'
      }
    ]
    customParameterValues: {}
    nonSecretParameterValues: {}
    createdTime: '2022-07-24T16:35:31.6713561Z'
    changedTime: '2022-07-26T11:35:40.9837388Z'
    api: {
      name: 'excelonlinebusiness'
      displayName: 'Excel Online (Business)'
      description: 'Excel Online (Business) connector lets you work with Excel files in document libraries supported by Microsoft Graph (OneDrive for Business, SharePoint Sites, and Office 365 Groups).'
      iconUri: 'https://connectoricons-prod.azureedge.net/releases/v1.0.1538/1.0.1538.2621/${connections_excelonlinebusiness_name}/icon.png'
      brandColor: '#107C41'
      id: '${subscription().id}/providers/Microsoft.Web/locations/${resourceLocation}/managedApis/${connections_excelonlinebusiness_name}'
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: '${subscription().id}/resourceGroups/${ResourceGroupName}/providers/Microsoft.Web/connections/${connections_excelonlinebusiness_name}/extensions/proxy/testconnection?api-version=2016-06-01'
        method: 'get'
      }

    ]
  }
}
