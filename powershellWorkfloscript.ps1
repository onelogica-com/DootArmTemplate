# Prompt user for GitHub Token
$GITHUB_TOKEN = Read-Host "Please enter your GitHub Token" -AsSecureString
$GITHUB_TOKEN = [System.Net.NetworkCredential]::new("", $GITHUB_TOKEN).Password

# Verify that the token is provided
if (-not $GITHUB_TOKEN) {
    Write-Host "Error: No GitHub token provided. Exiting."
    exit 1
}

# Replace these values for the first repository
$OWNER_1 = "anshupal667"        # Replace with your GitHub username or organization for repo 1
$REPO_1 = "glambot"             # Replace with the first repository name
$WORKFLOW_FILE_1 = "master_newarmwebdoot.yml" # Replace with your first workflow filename
$REF_1 = "master"               # Replace with the branch or tag to trigger the workflow on for repo 1

# Replace these values for the second repository
$OWNER_2 = "anshupal667"        # Replace with the GitHub username or organization for repo 2
$REPO_2 = "oldoot"              # Replace with the second repository name
$WORKFLOW_FILE_2 = "azure-webapps-node.yml"  # Replace with your second workflow filename
$REF_2 = "main"                 # Replace with the branch or tag to trigger the workflow on for repo 2

# Trigger Workflow 1 (Repo 1)
$URL_1 = "https://api.github.com/repos/$OWNER_1/$REPO_1/actions/workflows/$WORKFLOW_FILE_1/dispatches"
$Headers = @{
    "Accept" = "application/vnd.github+json"
    "Authorization" = "Bearer $GITHUB_TOKEN"
    "X-GitHub-Api-Version" = "2022-11-28"
}
$Body_1 = @{
    "ref" = $REF_1
} | ConvertTo-Json

$response_1 = Invoke-RestMethod -Uri $URL_1 -Method Post -Headers $Headers -Body $Body_1 -ContentType "application/json"
if ($response_1) {
    Write-Host "Workflow 1 triggered successfully in Repo 1"
} else {
    Write-Host "Failed to trigger Workflow 1 in Repo 1"
    exit 1  # Exit if the first workflow fails
}

# Trigger Workflow 2 (Repo 2)
$URL_2 = "https://api.github.com/repos/$OWNER_2/$REPO_2/actions/workflows/$WORKFLOW_FILE_2/dispatches"
$Body_2 = @{
    "ref" = $REF_2
} | ConvertTo-Json

$response_2 = Invoke-RestMethod -Uri $URL_2 -Method Post -Headers $Headers -Body $Body_2 -ContentType "application/json"
if ($response_2) {
    Write-Host "Workflow 2 triggered successfully in Repo 2"
} else {
    Write-Host "Failed to trigger Workflow 2 in Repo 2"
}
