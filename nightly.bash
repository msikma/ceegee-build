#!/usr/bin/env bash

echo "CeeGee nightly build script"
date
echo
if [ -z ${CEEGEE_ROOT_DIR+x} ]; then
  echo "Error: \$CEEGEE_ROOT_DIR is not set."
  exit 1
fi
if [ -z ${CEEGEE_BUILD_DEST_DIR+x} ]; then
  echo "Error: \$CEEGEE_BUILD_DEST_DIR is not set."
  echo "This is where build .zip files will be placed."
  exit 1
fi

cd "$CEEGEE_ROOT_DIR"
git checkout master
PREV_HASH=`git rev-parse HEAD`
git pull
CURR_HASH=`git rev-parse HEAD`

echo "Previous hash: $PREV_HASH"
echo "Current hash: $CURR_HASH"

if [ ! "$PREV_HASH" == "$CURR_HASH" ]; then
  echo "Making build."
  git pull
  make clean
  make DEBUG=1
  make dist DEBUG=1
  echo "Copying build to $CEEGEE_BUILD_DEST_DIR..."
  cp dist/*.zip "$CEEGEE_BUILD_DEST_DIR"
  echo "Done!"
else
  echo "No need to make a build."
fi