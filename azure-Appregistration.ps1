$APP_NAME = Read-Host -Prompt "Enter the App Name"
$SECRET_NAME = Read-Host -Prompt "Enter the Secret Description"

# Log in to Azure
az login

# Create the Azure AD App Registration
$APP_ID = az ad app create --display-name $APP_NAME --query appId --output tsv
Write-Output "App_ID=$APP_ID"

# Create a client secret for the app
$SECRET_VALUE = az ad app credential reset --id $APP_ID --append --query password --output tsv
Write-Output "Secret_Value=$SECRET_VALUE"

# Add the User.Read API permission (Microsoft Graph) to the app
az ad app permission add --id $APP_ID --api 00000003-0000-0000-c000-000000000000 --api-permissions e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope

# Grant the permissions for the app
az ad app permission grant --id $APP_ID --api 00000003-0000-0000-c000-000000000000

# Output the app details
Write-Output "App_Name=$APP_NAME"
Write-Output "Client_Secret=$SECRET_VALUE"
