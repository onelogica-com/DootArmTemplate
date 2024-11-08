#!/bin/bash

# Use token from environment variable or prompt for it if not provided
GITHUB_TOKEN=${GITHUB_TOKEN:-}

if [ -z "$GITHUB_TOKEN" ]; then
  echo "Please enter your GitHub Token: "
  read -sp "Token: " GITHUB_TOKEN
  echo
fi

# Replace these values for the first repository
OWNER_1="onelogica-com"             # GitHub username or organization for repo 1
REPO_1="dootbotcode"                # First repository name
WORKFLOW_FILE_1="master_Doot.yml"   # First workflow filename
REF_1="master"                      # Branch or tag to trigger the workflow on for repo 1

# Replace these values for the second repository
OWNER_2="onelogica-com"             # GitHub username or organization for repo 2
REPO_2="dootserver"                 # Second repository name
WORKFLOW_FILE_2="master_dootserver.yml"  # Second workflow filename
REF_2="master"                      # Branch or tag to trigger the workflow on for repo 2

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
