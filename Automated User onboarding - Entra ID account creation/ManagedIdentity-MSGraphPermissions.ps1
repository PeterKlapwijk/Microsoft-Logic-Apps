$ManagedIdentityObjectID = 'xx-xx' # Object (principal) ID of the Manage Identity. Found under Identity section of the Logic App on the System assigned tab
$GraphAppId = '00000003-0000-0000-c000-000000000000' # Microsoft Graph App ID (DON'T CHANGE!)
$TenantId = 'xx-xx'  # Your tenant id (found in the Azure Portal, under Azure Active Directory -> Overview )
$AssignMgPermissions = @(
    'User.ReadWrite.All',
    'GroupMember.ReadWrite.All' 
)

# Connect to Microsoft Graph
Connect-MgGraph -TenantId $DestinationTenantId

# Find the Microsoft Graph service principal details
$graphServicePrincipal = Get-MgServicePrincipal -Filter "appId eq '$GraphAppId'"


# Find the Microsoft Graph App role Ids for the specified permissions
$appRoles = $graphServicePrincipal.AppRoles | Where-Object { ($_.Value -in $AssignMgPermissions) -and ($_.AllowedMemberTypes -contains 'Application') }

# Assign the permission(s) to the managed identity:
foreach ($AppPermission in $appRoles) {
    $AppPermissionAssingment = @{
        'PrincipalId' = $ManagedIdentityObjectID
        'ResourceId'  = $graphServicePrincipal.Id
        'AppRoleId'   = $AppPermission.Id
    }
  
    New-MgServicePrincipalAppRoleAssignment `
        -ServicePrincipalId $AppPermissionAssingment.PrincipalId `
        -BodyParameter $AppPermissionAssingment `
        -Verbose
}