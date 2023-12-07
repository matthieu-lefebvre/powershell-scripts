#!/bin/bash
(echo n; echo p; echo 1;  ;  ; echo w) | fdisk /dev/sdc
mkfs.ext4 /dev/sdc1
mkdir /mnt/TTS
mount /dev/sdc1 /mnt/TTS
