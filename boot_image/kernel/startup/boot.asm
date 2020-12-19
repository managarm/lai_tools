section .bss
stack:
    resb 8192
  .top:

section .stivalehdr
stivale_header:
    dq stack.top
    dw 0
    dw 0
    dw 0
    dw 0
    dq 0
