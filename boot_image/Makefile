TARGET :=

CC = gcc

CFLAGS = -Wall -Wextra -O2 -pipe

LDINTERNALFLAGS := \
	-Tlinker.ld    \
	-nostdlib      \
	-pie -static-pie -fno-pic -fpie \
	-z max-page-size=0x1000

INTERNALCFLAGS  :=       \
	-I.                  \
	-I./lai/include      \
	-std=gnu11           \
	-ffreestanding       \
	-fno-stack-protector \
	-fno-pic -fpie       \
	-mgeneral-regs-only  \
	-mno-red-zone        \
	-masm=intel

CFILES := $(shell find -L ./ -type f -name '*.c' | grep -v limine)
OBJ    := $(CFILES:.c=.o)

KERNEL_HDD = test.hdd

.PHONY: all
all: $(KERNEL_HDD)

$(KERNEL_HDD): kernel.elf limine
	mkdir -p pack
	cp kernel.elf limine.cfg limine/limine.sys pack/
	mkdir -p pack/EFI/BOOT
	cp limine/BOOTX64.EFI pack/EFI/BOOT/
	./dir2fat32.sh -f $(KERNEL_HDD) 64 pack
	limine/limine-install $(KERNEL_HDD)

limine:
	git clone https://github.com/limine-bootloader/limine.git --branch=v2.0-branch-binary --depth=1
	make -C limine

kernel.elf: $(OBJ)
	$(CC) $(LDINTERNALFLAGS) $(OBJ) -o $@

%.o: %.c
	$(CC) $(CFLAGS) $(INTERNALCFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -rf $(TARGET) $(OBJ)

.PHONY: run
run:
	qemu-system-x86_64 -m 2G -net none -enable-kvm -cpu host -hda test.hdd -debugcon stdio
