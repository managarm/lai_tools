DEBUG = off

CC = gcc

C_FILES = $(shell find -L src -type f -name '*.c')
H_FILES = $(shell find -L . -type f -name '*.h')
ASM_FILES = $(shell find -L asm -type f -name '*.asm') $(shell find -L startup -type f -name '*.asm')
OBJ = $(C_FILES:.c=.o) $(ASM_FILES:.asm=.o)

CHARDFLAGS := \
    -std=gnu99 \
    -masm=intel \
    -fno-pic \
    -mno-80387 \
    -mno-mmx \
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

kernel.bin: $(OBJ) $(H_FILES)
	$(CC) $(OBJ) $(CLINKFLAGS) -T ./linker.ld -o $@
	$(CC) $(OBJ) $(CLINKFLAGS) -T ./linker-elf.ld -o kernel.elf

%.o: %.c
	$(CC) $(CHARDFLAGS) $(CFLAGS) -c $< -o $@

%.o: %.asm
	nasm $< -f elf64 -o $@

clean:
	rm -f $(OBJ) kernel.bin kernel.elf
