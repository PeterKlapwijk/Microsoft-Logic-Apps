![This is an image](https://www.inthecloud247.com/wp-content/uploads/2022/01/Azure-Logic-Apps-GitHub01.png)

## Instructions for deploying a custom template manually ##

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

## Instructions for automatically deploying second version

1. Fork this repository
2. Open [Azure cloud shell](https://shell.azure.com)
3. Clone the repository in cloud shell
4. Navigate to the `Intune RBAC - Country based device groups` folder
5. Run `.\deploy.ps1` - this script
    * will ask you to provide
        * the name of the Resource group
        * an Azure region (In case you don't know which regions are available, please run `az account list-locations -o table`)

        where you want your resources to be deployed
    * will deploy
        * the resource group
        * the Logic App
        * the user-assigned Managed Identity
        * the connection to SharePoint Online

Lastly, the required permissions of Microsoft Graph API will be assigned to the Managed Identity

Now let's make the connection work:

1. Log into the [Azure portal](https://portal.azure.com)
2. Select the resource group that you created by running the script
3. Navigate to the Logic App
. Browse to Api connections, select Edit connections
4. Select Authorize
5. Select Sign in
6. Select Save
7. Open the Logic app designer
8. Add your AAD User Group Object IDs to the Initialize variable action
9. Choose SharePoint site and List in the Get items action
10. Save the flow

*It takes a few minutes before the Graph permissions are active*

For more informations and the **requirements** for this Logic Apps flow read the related [Blog Post](https://www.inthecloud247.com/intune-rbac-create-country-based-device-groups-with-logic-apps/)
