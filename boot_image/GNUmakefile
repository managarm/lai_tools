define DEFAULT_VAR =
    ifeq ($(origin $1), default)
        override $(1) := $(2)
    endif
    ifeq ($(origin $1), undefined)
        override $(1) := $(2)
    endif
endef

$(eval $(call DEFAULT_VAR,CC,cc))
$(eval $(call DEFAULT_VAR,LD,ld))

CFLAGS ?= -Wall -Wextra -O2 -g -pipe
LDFLAGS ?=

override INTERNALLDFLAGS := \
	-Tlinker.ld             \
	-nostdlib               \
	-z max-page-size=0x1000 \
	-static

override INTERNALCFLAGS := \
	-I.                    \
	-I./lai/include        \
	-std=gnu11             \
	-ffreestanding         \
	-fno-stack-protector   \
	-fno-stack-check       \
	-fno-pic               \
	-fno-pie               \
	-mabi=sysv             \
	-mno-80387             \
	-mno-mmx               \
	-mno-3dnow             \
	-mno-sse               \
	-mno-sse2              \
	-mno-red-zone          \
	-mcmodel=kernel        \
	-MMD

override CFILES := $(shell find -L ./ -type f -name '*.c' | grep -v limine)
override OBJ := $(CFILES:.c=.o)
override HEADER_DEPS := $(CFILES:.c=.d)

.PHONY: all
all: test.iso

test.iso: kernel.elf limine
	mkdir -p pack
	cp kernel.elf limine.cfg limine/limine.sys limine/limine-cd.bin limine/limine-cd-efi.bin pack/
	xorriso -as mkisofs -b limine-cd.bin \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
        --efi-boot limine-cd-efi.bin \
        -efi-boot-part --efi-boot-image --protective-msdos-label \
        pack -o $@
	limine/limine-deploy $@

limine:
	git clone https://github.com/limine-bootloader/limine.git --branch=v3.0-branch-binary --depth=1
	make -C limine

limine.h:
	curl https://raw.githubusercontent.com/limine-bootloader/limine/trunk/limine.h -o $@

kernel.elf: $(OBJ)
	$(LD) $(OBJ) $(LDFLAGS) $(INTERNALLDFLAGS) -o $@

-include $(HEADER_DEPS)
%.o: %.c limine.h
	$(CC) $(CFLAGS) $(INTERNALCFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -rf kernel.elf test.iso $(OBJ) $(HEADER_DEPS) pack

.PHONY: distclean
distclean: clean
	rm -rf limine limine.h

.PHONY: run
run:
	qemu-system-x86_64 -M q35 -net none -enable-kvm -cpu host -hda test.iso -debugcon stdio
