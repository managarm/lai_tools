ENTRY(_start)

SECTIONS
{
    . = 0xffffffff80200000;

    .stivalehdr ALIGN(4K) :
    {
        KEEP(*(.stivalehdr))
    }

    .text ALIGN(4K) :
    {
        KEEP(*(.text*))
    }

    .data ALIGN(4K) :
    {
        KEEP(*(.data*))
        KEEP(*(.rodata*))
    }

    .bss ALIGN(4K) :
    {
        KEEP(*(COMMON))
        KEEP(*(.bss*))
    }
}
