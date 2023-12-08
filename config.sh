#!/bin/bash
(echo n; echo p; echo 1; echo ''; echo ''; echo w) | fdisk /dev/sdc
mkfs.ext4 /dev/sdc1
mkdir /mnt/TTS
mount /dev/sdc1 /mnt/TTS
chown -R ansible:ansible /mnt/TTS
