#!/bin/sh

set -e
cd "$(dirname "$0")"

FILE=./version.txt
if [ -f "$FILE" ]; then
  cat $FILE
else
  VERSION="$(date +"%Y%m%d%H%M")-SNAPSHOT"
  echo $VERSION > $FILE
  echo $VERSION
fi
