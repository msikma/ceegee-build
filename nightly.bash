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
  make dist DEBUG=1
  echo "Copying build to $CEEGEE_BUILD_DEST_DIR..."
  cp dist/*.zip "$CEEGEE_BUILD_DEST_DIR"
  echo "Symlinking latest file..."
  rm "$CEEGEE_BUILD_DEST_DIR"ceegee-master-debug-latest.zip
  ln -s `ls -td1 "$CEEGEE_BUILD_DEST_DIR"*.zip | head -n 1` "$CEEGEE_BUILD_DEST_DIR"ceegee-master-debug-latest.zip
  echo "Saving date and build info..."
  echo `git describe --all | sed s@heads/@@`-`git rev-list HEAD --count`-`git rev-parse --short HEAD` > "$CEEGEE_BUILD_DEST_DIR".latest-info
  date > "$CEEGEE_BUILD_DEST_DIR".latest-ts
  echo "Tweeting about the new release..."
  LATEST=`ls -td1 "$CEEGEE_ROOT_DIR"dist/*.zip | head -n 1`
  LATEST_BASE=`basename $LATEST`
  eval "$CEEGEE_TWTR_SCRIPT" --url="http://ceegee.whahay.com/nightly/$LATEST_BASE" --count=`git rev-list HEAD --count` --branch=`git describe --all | sed s@heads/@@` --hash=`git rev-parse --short HEAD` --atoken="$CEEGEE_TWTR_A_T" --asecret="$CEEGEE_TWTR_A_S" --ctoken="$CEEGEE_TWTR_C_T" --csecret="$CEEGEE_TWTR_C_S"
  echo "Done!"
else
  echo "No need to make a build."
fi
