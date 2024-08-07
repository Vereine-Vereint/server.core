#!/bin/bash
PATH_CORE=$(dirname $0)
PATH_ROOT=$PATH_CORE/..
PATH_FILES=$PATH_ROOT/files
set -e

# check .env
source $PATH_CORE/F-check-env.sh
check_env "$1" true

echo "Creating user-data for $HOSTNAME..."

# update SSH_IDENTITY_PRIVATE_KEY: replace "\n" with "\n        "
SSH_IDENTITY_PRIVATE_KEY=$(echo "$SSH_IDENTITY_PRIVATE_KEY" | sed ':a;N;$!ba;s/\n/\n        /g')

# copy user-data with changed variables
envsubst < $PATH_CORE/template/user-data > $PATH_FILES/source-files/server/user-data

echo "Creating image for $HOSTNAME..."

# create image
cd $PATH_FILES/source-files

rm -f ../$HOSTNAME.iso

xorriso -as mkisofs -r \
  -V 'Ubuntu 24.04 LTS AUTO (EFIBIOS)' \
  -o ../$HOSTNAME.iso \
  --grub2-mbr ../BOOT/1-Boot-NoEmul.img \
  -partition_offset 16 \
  --mbr-force-bootable \
  -append_partition 2 28732ac11ff8d211ba4b00a0c93ec93b ../BOOT/2-Boot-NoEmul.img \
  -appended_part_as_gpt \
  -iso_mbr_part_type a2a0d0ebe5b9334487c068b6b72699c7 \
  -c '/boot.catalog' \
  -b '/boot/grub/i386-pc/eltorito.img' \
  -no-emul-boot -boot-load-size 4 -boot-info-table --grub2-boot-info \
  -eltorito-alt-boot \
  -e '--interval:appended_partition_2:::' \
  -no-emul-boot \
  .

echo "[DONE] Image created."
