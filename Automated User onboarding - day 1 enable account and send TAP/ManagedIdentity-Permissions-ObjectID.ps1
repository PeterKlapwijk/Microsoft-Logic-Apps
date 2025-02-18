# Your tenant id (in Azure Portal, under Azure Active Directory -> Overview )
$TenantID="97e31759-7b8e-4ee9-a4ab-b365da3b5433"
# Object (principal) ID of the Manage Identity. Found under Identity section of the Logic App on the System assigned tab
$ObjectId="a997b123-f237-4489-8167-3c9f0b71f688" 
# Microsoft Graph App ID (DON'T CHANGE)
$AzureAppId = "00000003-0000-0000-c000-000000000000"
# Check the Microsoft Graph documentation for the permission you need for the operation
$PermissionNames =  "User.ReadWrite.All", "UserAuthenticationMethod.ReadWrite.All"

# Install the module (You need admin on the machine)
# Install-Module AzureAD 

#Connect-AzureAD -TenantId $TenantID 
#$MSI = (Get-AzureADServicePrincipal -Filter "displayName eq '$DisplayNameOfMSI'")
#Start-Sleep -Seconds 10
$GraphServicePrincipal = Get-AzureADServicePrincipal -Filter "appId eq '$AzureAppId'"

foreach ($PermissionName in $PermissionNames){
$AppRole = $GraphServicePrincipal.AppRoles | `
Where-Object {$_.Value -eq $PermissionName -and $_.AllowedMemberTypes -contains "Application"}
New-AzureAdServiceAppRoleAssignment -ObjectId $ObjectId -PrincipalId $ObjectId `
-ResourceId $GraphServicePrincipal.ObjectId -Id $AppRole.Id}