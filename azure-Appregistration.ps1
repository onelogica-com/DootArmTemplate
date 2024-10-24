param(
    [string] $APP_NAME,
    [string] $SECRET_NAME
)

# Create the Azure AD App Registration
$APP = New-AzADApplication -DisplayName $APP_NAME -IdentifierUris "https://token.botframework.com" -ReplyUrls "https://token.botframework.com/.auth/web/redirect" # Adjust your ReplyUrls as needed
$APP_ID = $APP.ApplicationId
Write-Output "App_ID=$APP_ID"

# Create a client secret for the app
$SECRET = New-AzADAppCredential -ApplicationId $APP_ID -Password (New-Guid).Guid
$SECRET_VALUE = $SECRET.SecretText
Write-Output "Secret_Value=$SECRET_VALUE"

# Output the app details
Write-Output "App_Name=$APP_NAME"
Write-Output "Client_Secret=$SECRET_VALUE"
