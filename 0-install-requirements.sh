#!/bin/bash
PATH_CORE=$(dirname $0)
PATH_ROOT=$PATH_CORE/..
PATH_FILES=$PATH_ROOT/files
set -e

echo "Installing requirements..."

sudo apt update

sudo apt install whois xorriso sed curl gpg isolinux p7zip-full mkisofs genisoimage

echo "[DONE] Requirements installed."
