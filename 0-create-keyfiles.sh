#!/bin/bash
PATH_CORE=$(dirname $0)
PATH_ROOT=$PATH_CORE/..
PATH_FILES=$PATH_ROOT/files
set -e

# root folder: server.organization
# use the root folder to find the organization name
cd $PATH_ROOT
FULL_PATH_ROOT=$(pwd)

# check if arg1 is set
if [ -z "$1" ]; then
  echo "Detecting organization from folder name..."
  REPOSITORY=$(basename $FULL_PATH_ROOT)
  ORGANIZATION=$(echo $REPOSITORY | cut -d'.' -f2)
else
  ORGANIZATION=$1
fi

echo "checking keyfiles for $ORGANIZATION:"

# check admin key
echo "  admin"
if [ ! -f "keys/${ORGANIZATION}_admin_key" ]; then
  echo "  generate admin key..."
  ssh-keygen -t rsa -b 4096 -N "" -C "admin@${ORGANIZATION}" -f keys/${ORGANIZATION}_admin_key
fi

# check backup key
echo "  backup"
if [ ! -f "keys/${ORGANIZATION}_backup_key" ]; then
  echo "  generate backup key..."
  ssh-keygen -t rsa -b 4096 -N "" -C "backup@${ORGANIZATION}" -f keys/${ORGANIZATION}_backup_key
fi

# create server list
for env_file in $(find . -maxdepth 1 -name "*.env"); do
  server_name=$(basename "$env_file" .env)
  echo "  server $server_name"
  # Add your code here to process each server name
  if [ ! -f "keys/${ORGANIZATION}_server_${server_name}_key" ]; then
    echo "    generate server key..."
    ssh-keygen -t rsa -b 4096 -N "" -C "server-${server_name}@${ORGANIZATION}" -f keys/${ORGANIZATION}_server_${server_name}_key
  fi
done

# fixing permissions
echo "fixing permissions..."
sudo chown -R $USER:$USER keys
sudo chmod 700 keys
sudo chmod 600 -R keys/*
