![This is an image](https://www.inthecloud247.com/wp-content/uploads/2022/01/Azure-Logic-Apps-GitHub01.png)

This Logic Apps flow sends a weekly report of your devices that are missing from the Windows Update for Business reports

## Instructions for automatically deploying the logic Apps flow ##

*The deployment script can be run from your local machine, by first cloning (downloading) the repository to your local machine. Or you can run the script using Azure cloud shell.
The script uses Azure CLI, if you run the script from your local machine install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) first*

1. Clone the repository to [Azure cloud shell](https://shell.azure.com) or to your local machine
2. Navigate to the `Windows Driver auto approval Patch Tuesday` folder
3. Run `.\deploy.ps1` - this script
    * will ask you to provide
        * the name of the Resource group (in which the Logic App needs to be created)
        * an Azure region (In case you don't know which regions are available, please run `az account list-locations -o table`)
        * the name of a (second) Resource group (in which the Log Analytics Workspace is located)

        where you want your resources to be deployed
    * will deploy
        * the resource group (if not already exists)
        * the Logic App
        * the user-assigned Managed Identity

Lastly, the required permissions of Microsoft Graph API will be assigned to the Managed Identity

Now let's make the flow work:

1. Log into the [Azure portal](https://portal.azure.com)
2. Select the resource group that you created by running the script
3. Navigate to the Logic App
4. Browse to API connections, Edit API connection. Click Authorize, sign in anc click Save (repeat for all connections)
5. Browse to Logic app designer
6. Configure the Recurrence trigger to your needs
7. Change the value in the Initialize variable action to your Log Analytics Worksopace ID
8. Select Site address and Folder path in the Create Excel file action
9. Select Location and Document Library in the Create table and the Add a row into a table actions
10. Select Site address in the Get file content action
11. Enter e-mail addresses in the Original mailbox Address and To field of the Send an email action 

*It takes a while before the Graph permissions are active, the first run of the flow might fail*

For more informations and the **requirements** for this Logic Apps flow read the related [Blog Post](https://www.inthecloud247.com/get-notifications-of-missing-devices-in-windows-update-for-business-report/)
