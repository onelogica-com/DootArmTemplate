param(
    [string] $APP_NAME,
    [string] $SECRET_NAME
)

# Log in to Azure (not needed in script, as it runs in Azure context)
# Instead, rely on the Managed Identity set in the ARM template

# Create the Azure AD App Registration
$APP = New-AzADApplication -DisplayName $APP_NAME -IdentifierUris "https://token.botframework.com" -ReplyUrls "https://token.botframework.com/.auth/web/redirect" # Adjust your ReplyUrls as needed
$APP_ID = $APP.ApplicationId
Write-Output "App_ID=$APP_ID"

# Create a client secret for the app
$SECRET = New-AzADAppCredential -ApplicationId $APP_ID -Password (New-Guid).Guid
$SECRET_VALUE = $SECRET.SecretText
Write-Output "Secret_Value=$SECRET_VALUE"

# Add the User.Read API permission (Microsoft Graph) to the app
$permissionId = "00000003-0000-0000-c000-000000000000"
$apiPermissionId = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"

# Grant the User.Read permission
New-AzADAppPermission -ApplicationId $APP_ID -ApiId $permissionId -Scope $apiPermissionId

# Grant admin consent for the permissions (requires admin rights)
Start-Sleep -Seconds 5 # Wait a moment before granting consent
New-AzADAppPermissionGrant -ApplicationId $APP_ID -ApiId $permissionId -Scope "/user.read"

# Output the app details
Write-Output "App_Name=$APP_NAME"
Write-Output "Client_Secret=$SECRET_VALUE"
