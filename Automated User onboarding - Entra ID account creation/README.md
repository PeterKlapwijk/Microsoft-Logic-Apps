![This is an image](https://www.inthecloud247.com/wp-content/uploads/2022/01/Azure-Logic-Apps-GitHub01.png)

For more information and the **requirements** for this Logic Apps flow read the related [Blog Post](https://inthecloud247.com/build-your-own-user-onboarding-automation-entra-id-user-account-creation/)

**Instructions for deploying one of the ARM templates in Azure**

1. Download the JSON file
1. Sign in to https://portal.azure.com
1. Search for Deploy a custom template
1. Click build your own template in the editor
1. Click Load file and select the JSON file.
1. Click Save
1. Select a Resource group and finish the deployment wizard
1. Open the Logic App
1. Browse to API connections under Development tools, Edit the SharePoint connection under General
1. Click Authorize
1. Sign in
1. Click Save
1. Repeat this steps for the office365 connection
1. Open Logic App designer
1. Set the Site Address and List Name in the SharePoint trigger and action
1. Change domainname.com to your own domain in the HTTP POST Create User
1. Set the Original Mailbox and To address in the Send and email actions
1. Add the Group Object ID in the HTTP Add Group member actions
1. Save the flow
1. Assign the required Application permissions with the attached PowerShell script

*The flow is ready to run, but keep in mind it could take some time before the permissions are active.*
