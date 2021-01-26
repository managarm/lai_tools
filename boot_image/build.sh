#!/bin/sh

set -ex

MAKE=gmake
command -v gmake || MAKE=make

if [ "$1" = "clean" ]; then
    $MAKE clean -C kernel
    exit 0
fi

[ -d limine ] || git clone https://github.com/limine-bootloader/limine.git --depth=1 --branch=v1.0-branch
$MAKE -C limine

$MAKE DEBUG=vga -C kernel

rm -f boot.hdd
dd if=/dev/zero bs=1M count=0 seek=64 of=boot.hdd
parted -s boot.hdd mklabel gpt
parted -s boot.hdd mkpart primary 2048s 100%

echfs-utils -g -p0 boot.hdd quick-format 512
echfs-utils -g -p0 boot.hdd import limine.cfg limine.cfg
echfs-utils -g -p0 boot.hdd import kernel/kernel.elf kernel.elf

./limine/limine-install ./limine/limine.bin ./boot.hdd
