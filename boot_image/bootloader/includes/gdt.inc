align 16

gdt_ptr:

dw gdt.end - gdt - 1
dd gdt

align 16

gdt:

; Null descriptor (required)

dw 0x0000			; Limit
dw 0x0000			; Base (low 16 bits)
db 0x00				; Base (mid 8 bits)
db 00000000b		; Access
db 00000000b		; Granularity
db 0x00				; Base (high 8 bits)

; Unreal mode

dw 0xFFFF			; Limit
dw 0x0000			; Base (low 16 bits)
db 0x00				; Base (mid 8 bits)
db 10011010b		; Access
db 10001111b		; Granularity
db 0x00				; Base (high 8 bits)

dw 0xFFFF			; Limit
dw 0x0000			; Base (low 16 bits)
db 0x00				; Base (mid 8 bits)
db 10010010b		; Access
db 10001111b		; Granularity
db 0x00				; Base (high 8 bits)

; Protected mode

dw 0xFFFF			; Limit
dw 0x0000			; Base (low 16 bits)
db 0x00				; Base (mid 8 bits)
db 10011010b		; Access
db 11001111b		; Granularity
db 0x00				; Base (high 8 bits)

dw 0xFFFF			; Limit
dw 0x0000			; Base (low 16 bits)
db 0x00				; Base (mid 8 bits)
db 10010010b		; Access
db 11001111b		; Granularity
db 0x00				; Base (high 8 bits)

.end:
