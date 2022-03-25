![This is an image](https://www.inthecloud247.com/wp-content/uploads/2022/01/Azure-Logic-Apps-GitHub01.png)

**Instructions for deploying a custom template manually**

1. Download the azuredeploy.json file
1. Sign in to https://portal.azure.com
1. Search for Deploy a custom template
1. Click build your own template in the editor
1. Click Load file and select azuredeploy.
1. Click Save
1. Select a Resource group
1. Enter the Managed Identity name
1. Click Review + create
1. Click Create
1. Search for Logic Apps
1. Open the Logic App
1. Browse to Api connections, Edit connection
1. Click Authorize
1. Sign in
1. Click Save
1. Browse to Identity, on the User assigned tab add the Managed Identity
1. Open the designer
1. Add your User group object IDs in the Initialize variable action
1. Check the HTTP actions for the Managed Identity
1. Choose SharePoint site and List in the Get items action
1. Done!

For more informations and the **requirements** for this Logic Apps flow read the related [Blog Post](https://www.inthecloud247.com/intune-rbac-create-country-based-device-groups-with-logic-apps/)

The automatic deployment with Bicep will follow.
