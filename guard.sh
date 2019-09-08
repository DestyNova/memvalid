#!/bin/bash
# Try to kill / build / restart the app.
# Requires the database to exist and a file named $ENV.secret
# (usually dev.secret) to be present in this directory, containing
# the database password. Make sure .gitignore excludes this file
# from being committed.

set -euo pipefail

APP_NAME=memvalid
APP_PATH=./target/$APP_NAME.exe
ENV=${1:-dev}

export SECRET_DB_PASSWD=`<$ENV.secret`

inotifywait -e close_write,moved_to -m './src' |
while read -r directory events filename; do
  if [[ "$filename" =~ .ur*$ ]]; then
    echo `tput setaf 0``tput setab 5`**** Building ****`tput sgr0`
    killall $APP_PATH || true
    "time" -f "Took %E" ./build.sh $APP_NAME && (
      echo `tput setaf 0``tput setab 5`**** Running ****`tput sgr0`
      $APP_PATH &
    )
  fi
done
