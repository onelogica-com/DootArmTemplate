#!/bin/bash

# Prompt user for GitHub Token
# Prompt user for GitHub Token
echo "Please enter your GitHub Token: "
read -sp "Token: " GITHUB_TOKEN
echo

# Verify that the token is provided
if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: No GitHub token provided. Exiting."
  exit 1
fi

# Replace these values for the first repository
OWNER_1="anshupal667"          # Replace with your GitHub username or organization for repo 1
REPO_1="glambot"               # Replace with the first repository name
WORKFLOW_FILE_1="master_newarmwebdoot.yml"  # Replace with your first workflow filename
REF_1="master"                 # Replace with the branch or tag to trigger the workflow on for repo 1

# Replace these values for the second repository
OWNER_2="anshupal667"        # Replace with the GitHub username or organization for repo 2
REPO_2="oldoot"          # Replace with the second repository name
WORKFLOW_FILE_2="azure-webapps-node.yml"  # Replace with your second workflow filename
REF_2="main"                   # Replace with the branch or tag to trigger the workflow on for repo 2

# Trigger Workflow 1 (Repo 1)
URL_1="https://api.github.com/repos/$OWNER_1/$REPO_1/actions/workflows/$WORKFLOW_FILE_1/dispatches"
curl -L -X POST "$URL_1" \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -d "{\"ref\":\"$REF_1\"}"

if [ $? -eq 0 ]; then
    echo "Workflow 1 triggered successfully in Repo 1"
else
    echo "Failed to trigger Workflow 1 in Repo 1"
    exit 1  # Exit if the first workflow fails
fi

# Trigger Workflow 2 (Repo 2)
URL_2="https://api.github.com/repos/$OWNER_2/$REPO_2/actions/workflows/$WORKFLOW_FILE_2/dispatches"
curl -L -X POST "$URL_2" \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -d "{\"ref\":\"$REF_2\"}"

if [ $? -eq 0 ]; then
    echo "Workflow 2 triggered successfully in Repo 2"
else
    echo "Failed to trigger Workflow 2 in Repo 2"
fi
 