![This is an image](https://www.inthecloud247.com/wp-content/uploads/2022/01/Azure-Logic-Apps-GitHub01.png)

For more information and the **requirements** for this Logic Apps flow read the related [Blog Post](https://inthecloud247.com/build-your-own-user-onboarding-automation-day-1-enable-the-account-and-create-a-temporary-access-pass/)

**Instructions for deploying one of the ARM templates in Azure**

1. Download the JSON file
1. Sign in to https://portal.azure.com
1. Search for Deploy a custom template
1. Click build your own template in the editor
1. Click Load file and select the JSON file.
1. Click Save
1. Select a Resource group and finish the deployment wizard
1. Open the Logic App when ready
1. Browse to API connections under Development tools, Edit the Office 365 connection under General
1. Click Authorize
1. Sign in
1. Click Save
1. Open Logic App designer, found under Development tools
1. Set the Original Mailbox address in the Send and email actions
1. Save the flow
1. Assign the required Application permissions with the attached PowerShell script

*The flow is ready to run, but keep in mind it could take some time before the permissions are active.*
