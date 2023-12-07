#!/bin/bash
(echo n; echo p; echo 1; echo 2048; echo 33554431; echo w) | fdisk /dev/sdc
mkfs.ext4 /dev/sdc1
mkdir /mnt/TTS
mount /dev/sdc1 /mnt/TTS
