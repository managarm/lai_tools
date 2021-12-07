CC ?= cc
LD ?= ld

CFLAGS ?= -Wall -Wextra -O2 -pipe
LDFLAGS ?=

INTERNALLDFLAGS :=          \
	-Tlinker.ld             \
	-nostdlib               \
	-z max-page-size=0x1000 \
	-ztext

INTERNALCFLAGS  :=       \
	-I.                  \
	-I./lai/include      \
	-std=gnu11           \
	-ffreestanding       \
	-fno-stack-protector \
	-fno-pic             \
	-mno-80387           \
	-mno-mmx             \
	-mno-3dnow           \
	-mno-sse             \
	-mno-sse2            \
	-mno-red-zone        \
	-mcmodel=kernel      \
	-MMD

CFILES      := $(shell find -L ./ -type f -name '*.c' | grep -v limine | grep -v lai_tools)
OBJ         := $(CFILES:.c=.o)
HEADER_DEPS := $(CFILES:.c=.d)

.PHONY: all
all: test.iso

test.iso: kernel.elf limine
	mkdir -p pack
	cp kernel.elf limine.cfg limine/limine.sys limine/limine-cd.bin limine/limine-eltorito-efi.bin pack/
	xorriso -as mkisofs -b limine-cd.bin \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
        --efi-boot limine-eltorito-efi.bin \
        -efi-boot-part --efi-boot-image --protective-msdos-label \
        pack -o $@
	limine/limine-install $@

limine:
	git clone https://github.com/limine-bootloader/limine.git --branch=v2.0-branch-binary --depth=1
	make -C limine

kernel.elf: $(OBJ)
	$(LD) $(OBJ) $(LDFLAGS) $(INTERNALLDFLAGS) -o $@

-include $(HEADER_DEPS)

%.o: %.c
	$(CC) $(CFLAGS) $(INTERNALCFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -rf kernel.elf test.iso $(OBJ) $(HEADER_DEPS)

.PHONY: distclean
distclean: clean
	rm -rf limine

.PHONY: run
run:
	qemu-system-x86_64 -M q35 -net none -enable-kvm -cpu host -hda test.iso -debugcon stdio
