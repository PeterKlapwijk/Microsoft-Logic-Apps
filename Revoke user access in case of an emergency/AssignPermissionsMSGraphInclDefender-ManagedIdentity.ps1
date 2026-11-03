<#
.SYNOPSIS
    Assigns Microsoft Defender for Endpoint (WindowsDefenderATP) application permissions
    to the managed identity of the "red button" Logic App.

.DESCRIPTION
    Replaces the AzureAD-module version of this script. The AzureAD module is retired,
    so this version uses the Microsoft Graph PowerShell SDK.
    Only assign these permissions when you have the correct Defender for Endpoint licenses.
    The script is idempotent: permissions that are already assigned are skipped.

.NOTES
    Run as a Global Administrator or Privileged Role Administrator.
    Requires: Microsoft.Graph.Authentication, Microsoft.Graph.Applications
#>

[CmdletBinding()]
param(
    # Your tenant id (Entra admin center -> Overview)
    [string]$TenantId = "xx-xx",

    # Object (principal) ID of the managed identity (Logic App -> Identity -> System assigned)
    [string]$ObjectId = "xx-xx"
)

$ErrorActionPreference = "Stop"

# WindowsDefenderATP app ID (DON'T CHANGE)
$DefenderAppId = "fc780465-2017-40d4-a0c5-307022471b92"

# Defender for Endpoint permissions used by the flow
$PermissionNames = @(
    "Machine.Read.All",  # Find the machine by name
    "Machine.Isolate"    # Isolate the machine
)

# Install the modules if needed (CurrentUser scope, no local admin required)
foreach ($Module in "Microsoft.Graph.Authentication", "Microsoft.Graph.Applications") {
    if (-not (Get-Module -ListAvailable -Name $Module)) {
        Install-Module $Module -Scope CurrentUser -Force
    }
}

Connect-MgGraph -TenantId $TenantId -NoWelcome -Scopes "Application.Read.All", "AppRoleAssignment.ReadWrite.All"

$DefenderServicePrincipal = Get-MgServicePrincipal -Filter "appId eq '$DefenderAppId'"
if (-not $DefenderServicePrincipal) {
    throw "WindowsDefenderATP service principal not found. Is Defender for Endpoint enabled in this tenant?"
}

$Existing = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $ObjectId -All |
    Where-Object { $_.ResourceId -eq $DefenderServicePrincipal.Id }

foreach ($PermissionName in $PermissionNames) {
    $AppRole = $DefenderServicePrincipal.AppRoles |
        Where-Object { $_.Value -eq $PermissionName -and $_.AllowedMemberTypes -contains "Application" }

    if (-not $AppRole) {
        Write-Warning "Permission '$PermissionName' not found on WindowsDefenderATP, skipped."
        continue
    }
    if ($Existing.AppRoleId -contains $AppRole.Id) {
        Write-Host "Already assigned: $PermissionName"
        continue
    }

    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $ObjectId `
        -PrincipalId $ObjectId -ResourceId $DefenderServicePrincipal.Id -AppRoleId $AppRole.Id | Out-Null
    Write-Host "Assigned: $PermissionName"
}

Disconnect-MgGraph | Out-Null
