![This is an image](https://www.inthecloud247.com/wp-content/uploads/2022/01/Azure-Logic-Apps-GitHub01.png)


## Instructions for automatically deploying the logic Apps flow ##

1. Fork this repository
2. Open [Azure cloud shell](https://shell.azure.com)
3. Clone the repository in cloud shell
4. Navigate to the `MEM Monitor security baselines in Endpoint Security` folder
5. Run `.\deploy.ps1` - this script
    * will ask you to provide
        * the name of the Resource group
        * an Azure region (In case you don't know which regions are available, please run `az account list-locations -o table`)

        where you want your resources to be deployed
    * will deploy
        * the resource group (if not already existing)
        * the Logic App
        * the user-assigned Managed Identity

Lastly, the required permissions of Microsoft Graph API will be assigned to the Managed Identity

Now let's make the flow work:

1. Log into the [Azure portal](https://portal.azure.com)
2. Select the resource group that you created by running the script
3. Navigate to the Logic App
4. Open the Logic app designer
5. Add your Webhook URL to the HTTP POST actions
6. Save the flow

*It takes a few minutes before the Graph permissions are active*

For more informations and the **requirements** for this Logic Apps flow read the related [Blog Post](https://www.inthecloud247.com/intune-rbac-create-country-based-device-groups-with-logic-apps/)
