param connections_SharePointOnline_name string = 'SharePointOnline'
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
    createdTime: '3/5/2022 12:48:50 PM'
    changedTime: '3/5/2022 12:48:58 PM'
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
