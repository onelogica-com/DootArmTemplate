
$APP_NAME = Read-Host -Prompt "Enter the App Name"
$SECRET_NAME = Read-Host -Prompt "Enter the Secret Description"
 
az login
 
$APP_ID = az ad app create --display-name $APP_NAME --query appId --output tsv
Write-Host "App Registration created with App ID: $APP_ID"
 
$SECRET_VALUE = az ad app credential reset --id $APP_ID --append --query password --output tsv
Write-Host "Client secret created with value: $SECRET_VALUE"
 
az ad app permission add --id $APP_ID --api 00000003-0000-0000-c000-000000000000 --api-permissions User.Read
az ad app permission grant --id $APP_ID --api 00000003-0000-0000-c000-000000000000
 
Write-Host "App Registration Name: $APP_NAME"
Write-Host "App ID: $APP_ID"
Write-Host "Client Secret: $SECRET_VALUE"