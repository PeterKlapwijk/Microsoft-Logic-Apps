[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $Location,
    [Parameter(Mandatory = $false)]
    [string]
    $SubscriptionId = "",
    [Parameter(Mandatory = $true)]
    [string]
    $ResourceGroupName

)
# Check subscription
if ($SubscriptionId -ne "") {
    az account set -s $SubscriptionId
    if (!$?) { 
        Write-Error "Unable to select $SubscriptionId as the active subscription."
        exit 1
    }
    Write-Host "Active Subscription set to $SubscriptionId"
} else {
    $Subscription = az account show | ConvertFrom-Json
    $SubscriptionId = $Subscription.id
    $SubscriptionName = $Subscription.name
    Write-Host "Active Subscription is $SubscriptionId ($SubscriptionName)"
}

Write-Host "Validating deployment location"
$ValidateLocation = az account list-locations --query "[?name=='$Location']" | ConvertFrom-Json
if ($ValidateLocation.Count -eq 0) {
    Write-Error "The location provided is not valid, the available locations for your account are:"
    az account list-locations --query [].name -o table
    exit 1
}

Write-Host "Creating Resource Group"
$ResourceGroup = az group create `
    --name $ResourceGroupName `
    --location $Location

$me = az ad signed-in-user show | ConvertFrom-Json
$roleAssignments = az role assignment list --all --assignee $me.id --query "[?resourceGroup=='$ResourceGroupName' && roleDefinitionName=='Contributor'].roleDefinitionName" | ConvertFrom-Json
if ($roleAssignments.Count -eq 0) {
    Write-Host "Current user does not have contributor permissions to $ResourceGroupName resource group, attempting to assign contributor permissions"
    az role assignment create --assignee $me.id --role contributor --resource-group $ResourceGroupName
}

$DeployTimestamp = (Get-Date).ToUniversalTime().ToString("yyyyMMdTHmZ")
# Deploy
az deployment group create `
    --name "DeployLinkedTemplate-$DeployTimestamp" `
    --resource-group $ResourceGroupName `
    --template-file ../"NotificationsMissingWUDevicesReport"/bicep/NotificationsMissingWUDevicesReport-root.bicep `
    --verbose

if (!$?) { 
        Write-Error "An error occured during the ARM deployment."
        exit 1
    }
    
Write-Host "Azure Logic App deployed, granting permissions to Managed Identity"

# get the Managed Identity principal ID
$ManagedIdentityName = "NotificationsMissingWUDevicesReport-ManagedIdentity"
$ManagedIdentity = az identity show --name $ManagedIdentityName --resource-group $ResourceGroupName | ConvertFrom-Json

$principalId = $ManagedIdentity.principalId
# Get current role assignments
$currentRoles = (az rest `
    --method get `
    --uri https://graph.microsoft.com/v1.0/servicePrincipals/$principalId/appRoleAssignedTo `
    | ConvertFrom-Json).value `
    | ForEach-Object { $_.appRoleId }

# Get Microsoft Graph ObjectId
$graphId = "00000003-0000-0000-c000-000000000000"

$graphversion = "v1.0"
$url = "https://graph.microsoft.com"
$endpoint = "servicePrincipals?`$filter="
$filter = "appId eq '$graphId'"

$uri = "$url/$graphversion/$endpoint$filter"

$graphResource = (az rest `
    --method get `
    --uri $uri `
   | ConvertFrom-Json).value

$graphResourceId = $graphResource.Id

#Get appRoleIds
$DeviceReadAll = az ad sp show --id $graphId --query "appRoles[?value=='Device.Read.All'].id | [0]" -o tsv

$appRoleIds = $DeviceReadAll
#Loop over all appRoleIds
foreach ($appRoleId in $appRoleIds) {
    $roleMatch = $currentRoles -match $appRoleId
    if ($roleMatch.Length -eq 0) {
        # Add the role assignment to the principal
        $body = "{'principalId': '$principalId',  'resourceId': '$graphResourceId',  'appRoleId': '$appRoleId'}";
        az rest `
            --method post `
            --uri https://graph.microsoft.com/v1.0/servicePrincipals/$principalId/appRoleAssignedTo `
            --body $body `
            --headers Content-Type=application/json 
    }
}

#Assign Azure rol Assignment "Log Analytics Reader" to the Managed Identity with the scope Resource Group
#As this RG of the Log Analytics Workspace might differ from the RG of the Logis Apps, the user is prompted for the RG Name
Write-Host "Assigning Azure role assignment to the Managed-Identity"
Write-Host "Provide Resource Group Name of the Log analytics Workspace"  -ForegroundColor DarkYellow
$ResourceGroupNameLA = Read-Host
$ManagedIdentityId = az ad sp list --display-name $ManagedIdentityName --query "[].{id:id}" --output tsv
$roleName = "Log Analytics Reader"

az role assignment create --assignee "$ManagedIdentityId" --role "$roleName" --scope "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupNameLA"

Write-Host "Deployment completed"