#!/bin/bash
PATH_CORE=$(dirname $0)
PATH_ROOT=$PATH_CORE/..
PATH_FILES=$PATH_ROOT/files
set -e

# check .env
source $PATH_CORE/F-check-env.sh
check_env "$1" true

echo "Uploading files to $HOSTNAME..."
