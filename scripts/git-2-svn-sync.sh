#!/usr/bin/env bash

if [[ -z "${SVN_USER}" || -z "${SVN_PASS}" ]] ; then
    echo "Please make sure both SVN_USER and SVN_PASS env variables are set!"
    exit 1;
fi

if [[ -z "${SVN_REPO_SLUG}" ]] ; then
    echo "Please make sure both SVN_REPO_SLUG env variable is set!"
    exit 1;
fi

# Bump plugin version if needed
if [ ! -z ${TRAVIS_TAG} ]; then
    make plugin_ver
fi

BUILD_DIR=${TRAVIS_BUILD_DIR}/svn
SVN_ROOT_DIR=${BUILD_DIR}/$(basename ${SVN_REPO_SLUG})
GIT_MESSAGE=$(git log -1 --pretty=%B)

# Sync SVN trunk with Git repo
cd ${SVN_ROOT_DIR}
rsync -av --checksum --delete ${TRAVIS_BUILD_DIR}/assets ${SVN_ROOT_DIR}/
rsync -av --checksum --delete --exclude-from=${TRAVIS_BUILD_DIR}/.svnignore ${TRAVIS_BUILD_DIR}/./ ${SVN_ROOT_DIR}/trunk
cd ${SVN_ROOT_DIR}/trunk
svn -q propset -R svn:ignore -F ${TRAVIS_BUILD_DIR}/.svnignore ${SVN_ROOT_DIR}/trunk # 2>/dev/null
echo "Run svn add"
svn st | grep '^!' | sed -e 's/\![ ]*/svn del -q /g' | sh
echo "Run svn del"
svn st | grep '^?' | sed -e 's/\?[ ]*/svn add -q /g' | sh
svn commit -m "${GIT_MESSAGE}" --username ${SVN_USER} --password ${SVN_PASS} --non-interactive --no-auth-cache # 2>/dev/null
