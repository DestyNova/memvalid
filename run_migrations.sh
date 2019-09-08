#!/usr/bin/env bash

set -euo pipefail

# careful now...
(echo "drop database if exists memvalid_ur; create database memvalid_ur; \c memvalid_ur" && cat src/memvalid.sql) | psql -U postgres -h localhost -f -
