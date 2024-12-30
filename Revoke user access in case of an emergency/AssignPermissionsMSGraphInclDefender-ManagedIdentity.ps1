#Basic script to assign application permissions for WindowsDefenderATP to a Managed Identity
#Only assign these permissions when you have the correct Defender for Endpoint licenses
#No error handling is in place

# Your tenant id (in Azure Portal, under Azure Active Directory -> Overview )
$TenantID="xx-xx"
# Object (principal) ID of the Manage Identity. Found under Identity section of the Logic App on the System assigned tab
$ObjectId="xx-xx" 
# WindowsDefenderATP App ID (DON'T CHANGE)
$GraphAppId = "fc780465-2017-40d4-a0c5-307022471b92"
# Check the Microsoft Graph documentation for the permission you need for the operation
$PermissionNames = "Machine.Read.All", "Machine.Isolate"

# Install the module (You need admin on the machine)
# Install-Module AzureAD 

Connect-AzureAD -TenantId $TenantID 
$GraphServicePrincipal = Get-AzureADServicePrincipal -Filter "appId eq '$GraphAppId'"

foreach ($PermissionName in $PermissionNames){
$AppRole = $GraphServicePrincipal.AppRoles | `
Where-Object {$_.Value -eq $PermissionName -and $_.AllowedMemberTypes -contains "Application"}
New-AzureAdServiceAppRoleAssignment -ObjectId $ObjectId -PrincipalId $ObjectId `
-ResourceId $GraphServicePrincipal.ObjectId -Id $AppRole.Id}