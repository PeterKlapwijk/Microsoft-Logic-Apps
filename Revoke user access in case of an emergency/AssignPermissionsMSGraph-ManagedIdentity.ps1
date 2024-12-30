#Basic script first assigns application permissions for Microsoft Graph to a Managed Identity, second assigns the User Administrator role
#No error handling is in place

# Your tenant id (found in the Azure Portal, under Azure Active Directory -> Overview )
$TenantID="xx-xx"
# Object (principal) ID of the Manage Identity. Found under Identity section of the Logic App on the System assigned tab
$ObjectId="xx-xx"
# Microsoft Graph App ID (DON'T CHANGE)
$AzureAppId = "00000003-0000-0000-c000-000000000000"
# Microsoft Graph permissions that will be assigned (DON'T CHANGE)
$PermissionNames =  "DeviceManagementManagedDevices.Read.All", "Device.ReadWrite.All", "User.ReadWrite.All", "UserAuthenticationMethod.ReadWrite.All", "DeviceManagementManagedDevices.PrivilegedOperations.All"
#Entra ID role displayname (DON'T CHANGE)
$displayName = "User Administrator"

# Install the module (You need admin on the machine)
# Install-Module AzureAD 

Connect-AzureAD -TenantId $TenantID 

#Assign Graph API permissions

$GraphServicePrincipal = Get-AzureADServicePrincipal -Filter "appId eq '$AzureAppId'"

foreach ($PermissionName in $PermissionNames){
$AppRole = $GraphServicePrincipal.AppRoles | `
Where-Object {$_.Value -eq $PermissionName -and $_.AllowedMemberTypes -contains "Application"}
New-AzureAdServiceAppRoleAssignment -ObjectId $ObjectId -PrincipalId $ObjectId `
-ResourceId $GraphServicePrincipal.ObjectId -Id $AppRole.Id}

# Assign the Entra ID role

$AdminRoleId = Get-AzureADDirectoryRole | Where-Object { $_.displayName -eq $displayName }
Add-AzureADDirectoryRoleMember -ObjectId $AdminRoleId.ObjectId -RefObjectId $ObjectId