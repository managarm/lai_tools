DEBUG = off

CC = gcc

C_FILES = $(shell find src -type f -name '*.c')
H_FILES = $(shell find . -type f -name '*.h')
ASM_FILES = $(shell find asm -type f -name '*.asm') $(shell find startup -type f -name '*.asm')
REAL_FILES = $(shell find blobs -type f -name '*.real')
OBJ = $(C_FILES:.c=.o) $(ASM_FILES:.asm=.o)
BINS = $(REAL_FILES:.real=.bin)

CHARDFLAGS := \
    -std=gnu99 \
    -masm=intel \
    -fno-pic \
    -mno-sse \
    -mno-sse2 \
    -mno-red-zone \
    -mcmodel=kernel \
    -ffreestanding \
    -fno-stack-protector \
    -I./include/ \
    -I./src/lai/include/

ifeq ($(DEBUG), qemu)
CHARDFLAGS := $(CHARDFLAGS) -D_KERNEL_QEMU_OUTPUT_
else ifeq ($(DEBUG), vga)
CHARDFLAGS := $(CHARDFLAGS) -D_KERNEL_VGA_OUTPUT_
endif

CLINKFLAGS := \
    -no-pie \
    -nostdlib

CFLAGS = -Wall -Wextra -O2

kernel.bin: $(BINS) $(OBJ) $(H_FILES)
	$(CC) $(OBJ) $(CLINKFLAGS) -T ./linker.ld -o $@
	$(CC) $(OBJ) $(CLINKFLAGS) -T ./linker-elf.ld -o kernel.elf

%.o: %.c
	$(CC) $(CHARDFLAGS) $(CFLAGS) -c $< -o $@

%.bin: %.real
	nasm $< -f bin -o $@

%.o: %.asm
	nasm $< -f elf64 -o $@

clean:
	rm -f $(OBJ) $(BINS) kernel.bin kernel.elf
