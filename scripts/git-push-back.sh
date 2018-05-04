#!/usr/bin/env bash

echo "Pushing back to GitHub"

cd ${TRAVIS_BUILD_DIR}

# Bump plugin version
make plugin_ver

# Set up Travis user
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

# Prevent Git from tracking file mode changes
git config core.fileMode false

# Commit files
git add .
git commit --message "pushing back Travis CI tagged build: ${TRAVIS_BUILD_NUMBER}"

# Push files back to Git
GH_ORIGIN=$(git config --get remote.origin.url)
GH_ORIGIN=${GH_ORIGIN//https:\/\//}
git remote add origin-with-token https://${GH_TOKEN}@${GH_ORIGIN} > /dev/null 2>&1
git push --quiet --set-upstream origin-with-token master
