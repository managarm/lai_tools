section .rodata

gdt:
    dw .size - 1    ; GDT size
    dq .start       ; GDT start address

  .start:
    ; Null desc
    dq 0

    ; 64-bit code
    dw 0x0000       ; Limit
    dw 0x0000       ; Base (low 16 bits)
    db 0x00         ; Base (mid 8 bits)
    db 10011010b    ; Access
    db 00100000b    ; Granularity
    db 0x00         ; Base (high 8 bits)

    ; 64-bit data
    dw 0x0000       ; Limit
    dw 0x0000       ; Base (low 16 bits)
    db 0x00         ; Base (mid 8 bits)
    db 10010010b    ; Access
    db 00000000b    ; Granularity
    db 0x00         ; Base (high 8 bits)

  .end:

  .size: equ .end - .start

section .text

global init_gdt
init_gdt:
    lgdt [gdt]

    push 0x08
    push .loadcs
    retfq
  .loadcs:
    mov eax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ret
