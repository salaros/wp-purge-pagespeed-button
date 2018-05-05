#!/usr/bin/env bash

if [[ -z "${SVN_USER}" || -z "${SVN_PASS}" ]] ; then
    echo "Please make sure both SVN_USER and SVN_PASS env variables are set!"
    exit 1;
fi

export SVN_REPO_SLUG=${TRAVIS_BUILD_DIR##*/}
if [[ -z "${SVN_REPO_SLUG}" ]] ; then
    echo "Please make sure both SVN_REPO_SLUG env variable is set!"
    exit 1;
fi

# Go out if Travis CI Git tag-related
# environment variable is not set
if [ -z ${TRAVIS_TAG} ]; then
    echo "Skipping SVN tag creation since it's not a tag-tiggered build"
    exit 0;
fi

BUILD_DIR=${TRAVIS_BUILD_DIR}/svn
SVN_ROOT_DIR=${BUILD_DIR}/$(basename ${SVN_REPO_SLUG})
SVN_TAG_DIR=${SVN_ROOT_DIR}/tags/${TRAVIS_TAG}
SVN_TRUNK_DIR=${SVN_ROOT_DIR}/trunk

# Bump plugin version
cd ${SVN_TRUNK_DIR}
make plugin_ver


# ================  SVN TRUNK  =================
echo "Updating SVN trunk"

# Add stuff to SVN to ignore list
svn -q propset -R svn:ignore -F ${TRAVIS_BUILD_DIR}/.svnignore ${SVN_TRUNK_DIR} # 2>/dev/null

# Add stuff to SVN and commit files
svn add --force ${SVN_TRUNK_DIR}/ # 2>/dev/null
svn commit -m "bumping plugin version to ${TRAVIS_TAG}" --username ${SVN_USER} --password ${SVN_PASS} --non-interactive --no-auth-cache # 2>/dev/null


# ==================  SVN TAG  ==================
echo "Updating SVN tag ${TRAVIS_TAG}"
# Copy SVN trunk to a tag and commit it
rsync -av --checksum --delete ${SVN_TRUNK_DIR}/./ ${SVN_TAG_DIR}
cd ${SVN_TAG_DIR}

# Add stuff to SVN to ignore list
svn -q propset -R svn:ignore -F ${TRAVIS_BUILD_DIR}/.svnignore ${SVN_TAG_DIR} # 2>/dev/null

# Add stuff to SVN and commit files
svn add --force ${SVN_TAG_DIR}/ # 2>/dev/null
svn commit -m "bumping plugin version to ${TRAVIS_TAG}" --username ${SVN_USER} --password ${SVN_PASS} --non-interactive --no-auth-cache # 2>/dev/null
