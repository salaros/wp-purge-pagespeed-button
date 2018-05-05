#!/usr/bin/env bash

echo "Pushing back to GitHub"

cd ${TRAVIS_BUILD_DIR}

# Bump plugin version
make plugin_ver

# Prepare repo
git log  --pretty=oneline | head -n 5
git checkout -b ${GITHUB_PUSHBACK_BRANCH}
git branch
git pull -f

# Set up Travis user
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

# Prevent Git from tracking file mode changes
git config --global core.fileMode false
git config core.fileMode false

# Commit files
git add .
git commit --message "pushing back Travis CI tagged build: ${TRAVIS_BUILD_NUMBER}"

# Manipulate Git origin's URL
GH_ORIGIN=$(git config --get remote.origin.url)
GH_ORIGIN=${GH_ORIGIN//https:\/\//}
GH_ORIGIN=${GH_ORIGIN/:/\/}
GH_ORIGIN=${GH_ORIGIN/git@/}
git remote remove origin-with-token
git remote add origin-with-token https://${GH_TOKEN}@${GH_ORIGIN} > /dev/null 2>&1
echo $(git config --get remote.origin-with-token.url)

# Push files back to Git
git push -u origin-with-token ${GITHUB_PUSHBACK_BRANCH}
