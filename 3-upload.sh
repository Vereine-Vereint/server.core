#!/bin/bash
PATH_CORE=$(dirname $0)
PATH_ROOT=$PATH_CORE/..
PATH_FILES=$PATH_ROOT/files
set -e

# check .env
source $PATH_CORE/F-check-env.sh
check_env "$1" true

echo "Uploading $HOSTNAME.iso..."

# upload to FTP server
ftp -n <<EOF
open $FTP_SERVER
user $FTP_USER $FTP_PASSWORD
put $PATH_FILES/$HOSTNAME.iso boot.iso
bye
EOF

echo "[DONE] Upload completed."
