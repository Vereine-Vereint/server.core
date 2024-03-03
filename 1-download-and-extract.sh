#!/bin/bash

set -e
# cd ..

mkdir -p files 
cd files

if [ ! -f "jammy-live-server-amd64.iso" ]; then
  wget https://cdimage.ubuntu.com/ubuntu-server/jammy/daily-live/current/jammy-live-server-amd64.iso
fi

rm -rf 'source-files'
7z -y x jammy-live-server-amd64.iso -osource-files
rm -rf 'source-files/[BOOT]'

mkdir source-files/server

touch source-files/server/meta-data

# Find the first occurrence of "menuentry" in source-files/boot/grub/grub.cfg
# and replace it with the contents of ../core/template/grob.cfg.addon
awk '/menuentry/{c++;if(c==1){system("cat ../core/template/grub.cfg.addon")}}1' source-files/boot/grub/grub.cfg > source-files/boot/grub/grub.cfg.tmp
mv source-files/boot/grub/grub.cfg.tmp source-files/boot/grub/grub.cfg