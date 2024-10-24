param(
    [string] [Parameter(Mandatory=$false)] $APP_NAME = "MyAppName",  # Hardcoded app name
    [string] [Parameter(Mandatory=$false)] $SECRET_NAME = "MyAppSecret"  # Hardcoded secret name
)

$ErrorActionPreference = 'Stop'
$DeploymentScriptOutputs = @{}

# Check if the Azure AD app already exists
$existingApp = Get-AzADApplication -DisplayName $APP_NAME -ErrorAction SilentlyContinue

if ($existingApp) {
    $DeploymentScriptOutputs['App_ID'] = $existingApp.ApplicationId
    Write-Output "Existing App found: $APP_NAME"
} else {
    # Create the Azure AD App Registration
    $APP = New-AzADApplication -DisplayName $APP_NAME -IdentifierUris "https://token.botframework.com" -ReplyUrls "https://token.botframework.com/.auth/web/redirect" # Adjust your ReplyUrls as needed
    $DeploymentScriptOutputs['App_ID'] = $APP.ApplicationId
    Write-Output "Created new App: $APP_NAME"
}

# Create a client secret for the app
$SECRET = New-AzADAppCredential -ApplicationId $DeploymentScriptOutputs['App_ID'] -Password (New-Guid).Guid
$DeploymentScriptOutputs['Client_Secret'] = $SECRET.SecretText

# Output the app details
Write-Output "App_Name=$APP_NAME"
Write-Output "Client_Secret=$($DeploymentScriptOutputs['Client_Secret'])"

# Return outputs for ARM template
$DeploymentScriptOutputs | ConvertTo-Json -Depth 10
