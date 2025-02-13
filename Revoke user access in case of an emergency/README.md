![This is an image](https://www.inthecloud247.com/wp-content/uploads/2022/01/Azure-Logic-Apps-GitHub01.png)

For more information and the **requirements** for this Logic Apps flow read the related [Blog Post](https://inthecloud247.com/revoke-user-access-in-case-of-an-emergency-with-a-single-click/)

**Instructions for deploying one of the ARM templates in Azure**

1. Download the json file
1. Sign in to https://portal.azure.com
1. Search for Deploy a custom template
1. Click build your own template in the editor
1. Click Load file and select the JSON file.
1. Click Save
1. Select a Resource group and finish the deployment wizard
1. Open the Logic App
1. Browse to Api connections, Edit the sharepoint connection
1. Click Authorize
1. Sign in
1. Click Save
1. Open Logic App designer
1. Add the object id of the Entra ID group
1. Add Site Address and List Name to all SharePoint actions
1. Save the flow
1. Assign the required Application permissions and Entra ID role (for example by using the attached scripts)

*The flow is ready to run, but keep in mind it could take some time before the permissions are active.*
