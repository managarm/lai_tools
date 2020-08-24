org 0x7c00
bits 16

cli
jmp 0x0000:initialise_cs
initialise_cs:
xor ax, ax
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax
mov sp, 0x7c00
sti

; load rest of bootloader

mov eax, 1
mov ebx, 0x7e00
mov ecx, 1
call read_sectors
jc err

mov si, LoadingMsg
call simple_print

; ***** A20 *****

mov si, A20Msg
call simple_print

call enable_a20
jc err

mov si, DoneMsg
call simple_print

; ***** Unreal Mode *****

mov si, UnrealMsg
call simple_print

lgdt [gdt_ptr]

; enter unreal mode

cli

mov eax, cr0
or eax, 00000001b
mov cr0, eax

mov ax, 0x10
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax

mov eax, cr0
and eax, 11111110b
mov cr0, eax

xor ax, ax
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax

sti

mov si, DoneMsg
call simple_print

; ***** Kernel *****

; Load the kernel at 0x100000 (1 MiB)

mov si, KernelMsg
call simple_print

mov eax, 2
mov ebx, 0x100000
mov ecx, 510
call read_sectors
jc err

mov si, DoneMsg
call simple_print

; 80x50 text mode
pusha
mov ax, 0x1112
xor bx, bx
int 0x10
popa

call get_e820
call flush_irqs

; enter pmode

cli

mov eax, cr0
or eax, 00000001b
mov cr0, eax

jmp 0x18:pmode

bits 32
pmode:
mov ax, 0x20
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax

mov esp, 0xeffff0

jmp 0x100000        ; jump to kernel

bits 16

err:
mov si, ErrMsg
call simple_print

halt:
hlt
jmp halt

ErrMsg db 0x0d, 0x0a, 'Err system halted', 0

%include 'includes/disk.inc'
%include 'includes/simple_print.inc'

; Add a fake MBR because some motherboards won't boot otherwise

times 0x1b8-($-$$) db 0
mbr:
    .signature: dd 0xdeadbeef
    times 2 db 0
    .p1:
        db 0x80         ; status (active)
        db 0x20, 0x21, 0x00    ; CHS start
        db 0x83         ; partition type (Linux)
        db 0xb6, 0x25, 0x51    ; CHS end
        dd disk_start/512   ; LBA start
        dd disk_size/512    ; size in sectors
    .p2:
        db 0x00         ; status (invalid)
        times 3 db 0    ; CHS start
        db 0x00         ; partition type
        times 3 db 0    ; CHS end
        dd 00           ; LBA start
        dd 00           ; size in sectors
    .p3:
        db 0x00         ; status (invalid)
        times 3 db 0    ; CHS start
        db 0x00         ; partition type
        times 3 db 0    ; CHS end
        dd 00           ; LBA start
        dd 00           ; size in sectors
    .p4:
        db 0x00         ; status (invalid)
        times 3 db 0    ; CHS start
        db 0x00         ; partition type
        times 3 db 0    ; CHS end
        dd 00           ; LBA start
        dd 00           ; size in sectors

times 510-($-$$) db 0x00
dw 0xaa55

; start of LBA sector 1

; grab e820 and put it at 0x500

get_e820:
    pushad
    xor ebx, ebx
    mov edi, 0x500
  .loop:
    mov eax, 0xe820
    mov ecx, 24
    mov edx, 0x534d4150
    push edi
    int 0x15
    pop edi
    jc .done
    add edi, 24
    test ebx, ebx
    jz .done
    jmp .loop
  .done:
    xor al, al
    mov cx, 24
    rep stosb
    popad
    ret

flush_irqs:
    pusha
    cli
    mov al, 0xff
    out 0x21, al
    out 0xa1, al
    sti

    xor al, al
    mov cx, 0x1000
  .loop:
    out 0x80, al
    loop .loop

    popa
    ret

%include 'includes/a20_enabler.inc'
%include 'includes/gdt.inc'

LoadingMsg db 0x0d, 0x0a, 'Loading...', 0x0d, 0x0a, 0x0a, 0
A20Msg db 'Enabling A20 line...', 0
UnrealMsg db 'Entering Unreal Mode...', 0
KernelMsg db 'Loading kernel...', 0
DoneMsg db '  DONE', 0x0d, 0x0a, 0

times 1024-($-$$)           db 0

; start of LBA sector 2

incbin '../kernel/kernel.bin'

; bootloader is 256kb / 512 sectors
times (512*512)-($-$$) db 0x00

; padding for partition alignment
times (2048*512)-($-$$) db 0x00

; start of primary partition
disk_start equ ($ - $$)
disk_size equ (disk_end - disk_start)
times (4096*512)-($-$$) db 0x00
disk_end equ ($ - $$)
