# Hardcoded values for the application name and secret name
$APP_NAME = "dootaadtest"  # Replace with your desired app name
$SECRET_NAME = "AADdootAppSecret" # Replace with your desired secret name

try {
    # Create the Azure AD App Registration
    $APP = New-AzADApplication -DisplayName $APP_NAME -IdentifierUris "https://token.botframework.com" -ReplyUrls "https://token.botframework.com/.auth/web/redirect"
    $APP_ID = $APP.ApplicationId
    Write-Output "App_ID=$APP_ID"

    # Create a client secret for the app
    $SECRET = New-AzADAppCredential -ApplicationId $APP_ID -Password (New-Guid).Guid
    $SECRET_VALUE = $SECRET.SecretText
    Write-Output "Secret_Value=$SECRET_VALUE"

    # Output the app details
    Write-Output "App_Name=$APP_NAME"
    Write-Output "Client_Secret=$SECRET_VALUE"
} catch {
    Write-Error "Error occurred: $_"
    exit 1
}
