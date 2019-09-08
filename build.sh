#!/bin/bash
# Build the app and put its .exe in the target directory

set -euo pipefail

APPNAME=$1

rm -rf target && mkdir target
cd src
urweb $1 -db "dbname=memvalid_ur host=localhost user=postgres password=$SECRET_DB_PASSWD" -output ../target/$1.exe
