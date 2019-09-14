#!/bin/bash
# Build the app and put its .exe in the target directory

set -euo pipefail

APPNAME=$1

rm -rf target && mkdir target
cd src
# interestingly, the path supplied to the "-db" argument is relative to
# where the app will be running from, NOT necessarily the directory we're
# running the compiler from.
urweb $1 -dbms sqlite -db target/db.sqlite -output ../target/$1.exe -endpoints ../target/endpoints.json
