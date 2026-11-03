<#
.SYNOPSIS
    Assigns Microsoft Graph application permissions and the User Administrator role
    to the managed identity of the "red button" Logic App.

.DESCRIPTION
    Replaces the AzureAD-module version of this script. The AzureAD module is retired,
    so this version uses the Microsoft Graph PowerShell SDK.
    The script is idempotent: permissions or roles that are already assigned are skipped.

.NOTES
    Run as a Global Administrator or Privileged Role Administrator.
    Requires: Microsoft.Graph.Authentication, Microsoft.Graph.Applications,
              Microsoft.Graph.Identity.Governance
#>

[CmdletBinding()]
param(
    # Your tenant id (Entra admin center -> Overview)
    [string]$TenantId = "xx-xx",

    # Object (principal) ID of the managed identity (Logic App -> Identity -> System assigned)
    [string]$ObjectId = "xx-xx",

    # Add the permission needed for the on-premises AD integration (API-driven provisioning bulkUpload)
    [switch]$IncludeOnPremProvisioning
)

$ErrorActionPreference = "Stop"

# Microsoft Graph app ID (DON'T CHANGE)
$GraphAppId = "00000003-0000-0000-c000-000000000000"

# Microsoft Graph application permissions used by the flow (DON'T CHANGE)
$PermissionNames = @(
    "DeviceManagementManagedDevices.Read.All",                # Read Intune managed devices
    "DeviceManagementManagedDevices.PrivilegedOperations.All", # Retire, wipe, lock, reboot
    "Device.ReadWrite.All",                                   # Disable Entra device objects
    "User.ReadWrite.All",                                     # Read user, disable account, revoke sessions, reset password
    "UserAuthenticationMethod.ReadWrite.All"                  # Delete authentication methods
)
if ($IncludeOnPremProvisioning) {
    $PermissionNames += "SynchronizationData-User.Upload"     # bulkUpload to the API-driven provisioning job
}

# Entra ID role (DON'T CHANGE). Template ID of User Administrator is the same in every tenant.
$RoleDefinitionId = "fe930be7-5e62-47db-91af-98c3a49a38b1"

# Install the modules if needed (CurrentUser scope, no local admin required)
foreach ($Module in "Microsoft.Graph.Authentication", "Microsoft.Graph.Applications", "Microsoft.Graph.Identity.Governance") {
    if (-not (Get-Module -ListAvailable -Name $Module)) {
        Install-Module $Module -Scope CurrentUser -Force
    }
}

Connect-MgGraph -TenantId $TenantId -NoWelcome -Scopes `
    "Application.Read.All", "AppRoleAssignment.ReadWrite.All", "RoleManagement.ReadWrite.Directory"

# Assign Graph API permissions
$GraphServicePrincipal = Get-MgServicePrincipal -Filter "appId eq '$GraphAppId'"
$Existing = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $ObjectId -All |
    Where-Object { $_.ResourceId -eq $GraphServicePrincipal.Id }

foreach ($PermissionName in $PermissionNames) {
    $AppRole = $GraphServicePrincipal.AppRoles |
        Where-Object { $_.Value -eq $PermissionName -and $_.AllowedMemberTypes -contains "Application" }

    if (-not $AppRole) {
        Write-Warning "Permission '$PermissionName' not found on Microsoft Graph, skipped."
        continue
    }
    if ($Existing.AppRoleId -contains $AppRole.Id) {
        Write-Host "Already assigned: $PermissionName"
        continue
    }

    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $ObjectId `
        -PrincipalId $ObjectId -ResourceId $GraphServicePrincipal.Id -AppRoleId $AppRole.Id | Out-Null
    Write-Host "Assigned: $PermissionName"
}

# Assign the Entra ID role (works also when the role was never activated in the tenant)
$RoleAssignment = Get-MgRoleManagementDirectoryRoleAssignment -All `
    -Filter "principalId eq '$ObjectId' and roleDefinitionId eq '$RoleDefinitionId'"

if ($RoleAssignment) {
    Write-Host "Already assigned: User Administrator role"
}
else {
    New-MgRoleManagementDirectoryRoleAssignment -PrincipalId $ObjectId `
        -RoleDefinitionId $RoleDefinitionId -DirectoryScopeId "/" | Out-Null
    Write-Host "Assigned: User Administrator role"
}

Disconnect-MgGraph | Out-Null
