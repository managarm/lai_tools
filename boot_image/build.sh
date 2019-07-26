#!/bin/sh

set -e

MAKE=gmake
command -v gmake || MAKE=make

if [ "$1" = "clean" ]; then
    $MAKE clean -C kernel
    $MAKE clean -C bootloader
    exit 0
fi

cd kernel/src
git clone https://github.com/qword-os/lai.git || true
cd lai && git pull
cd ../../..

$MAKE DEBUG=vga -C kernel
$MAKE -C bootloader
mv bootloader/bootloader.bin ./boot.hdd
