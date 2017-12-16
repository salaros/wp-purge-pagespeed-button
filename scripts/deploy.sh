#!/usr/bin/env bash

if [[ -z "${SVN_USER}" || -z "${SVN_PASS}" ]] ; then
    echo "Please make sure both SVN_USER and SVN_PASS env variables are set!"
    exit 1;
fi

if [[ -z "${SVN_REPO_SLUG}" ]] ; then
    echo "Please make sure both SVN_REPO_SLUG env variable is set!"
    exit 1;
fi

BUILD_DIR=${TRAVIS_BUILD_DIR}/svn
SVN_ROOT_DIR=${BUILD_DIR}/$(basename ${SVN_REPO_SLUG})
SVN_TAG_DIR=${SVN_ROOT_DIR}/tags/${TRAVIS_TAG}

# Sync SVN trunk with Git repo
cd ${SVN_ROOT_DIR}
rsync -av --checksum --delete ${TRAVIS_BUILD_DIR}/assets ${SVN_ROOT_DIR}/
rsync -av --checksum --delete --exclude-from=${TRAVIS_BUILD_DIR}/.svnignore ${TRAVIS_BUILD_DIR}/./ ${SVN_ROOT_DIR}/trunk
cd ${SVN_ROOT_DIR}/trunk
svn -q propset -R svn:ignore -F ${TRAVIS_BUILD_DIR}/.svnignore ${SVN_ROOT_DIR}/trunk # 2>/dev/null
svn commit -m "synched Git repo to SVN" --username ${SVN_USER} --password ${SVN_PASS} --non-interactive --no-auth-cache # 2>/dev/null

# Go out if Travis CI Git tag-related 
# environment variable is not set
if [ -z ${TRAVIS_TAG} ]; then
    echo "Skipping SVN tag creation since it's not a tag-tiggered build"
    exit 0;
fi

# Copy SVN trunk to a tag
rsync -av --checksum --delete ${SVN_ROOT_DIR}/trunk/./ ${SVN_TAG_DIR}
cd ${SVN_TAG_DIR}
svn -q propset -R svn:ignore -F ${TRAVIS_BUILD_DIR}/.svnignore ${SVN_TAG_DIR} # 2>/dev/null
svn add --force ${SVN_TAG_DIR}/ # 2>/dev/null
svn commit -m "bumping plugin version to ${TRAVIS_TAG}" --username ${SVN_USER} --password ${SVN_PASS} --non-interactive --no-auth-cache # 2>/dev/null
