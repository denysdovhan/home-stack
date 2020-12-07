#!/bin/bash

CURRENT_BRANCH="${1:-$(git name-rev --name-only HEAD)}"

echo "Current branch is $CURRENT_BRANCH"
echo "Pulling latest updates from GitHub..."

git pull origin $CURRENT_BRANCH
git status
