#!/bin/bash

pushd "$HOME_STACK_DIR" || exit

CURRENT_BRANCH="${1:-$(git name-rev --name-only HEAD)}"

echo "Current branch is $CURRENT_BRANCH"
echo "Pulling latest updates from GitHub..."

git pull origin $CURRENT_BRANCH
git status

popd > /dev/null 2>&1 || exit
