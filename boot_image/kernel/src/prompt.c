#include <stddef.h>
#include <stdint.h>
#include <keyboard.h>
#include <klib.h>
#include <acpi.h>
#include <cio.h>
#include <serial.h>
#include <lai/host.h>

static uint64_t strtoui(const char *s) {
    uint64_t n = 0;
    while (*s)
        n = n * 10 + ((*(s++)) - '0');
    return n;
}

static void dump_sdt(void) {
    char signature[8];
    kprint(KPRN_RAW, "table signature: ");
    gets(signature, 8);
    char index_s[8];
    kprint(KPRN_RAW, "table index: ");
    gets(index_s, 8);
    size_t index = strtoui(index_s);

    acpi_sdt_t *sdt = laihost_scan(signature, index);
    if (!sdt)
        return;
    kprint(KPRN_RAW, "address of %s is %X\n", signature, sdt);
    kprint(KPRN_RAW, "%s length: %u bytes\n", signature, sdt->length);
    kprint(KPRN_RAW, "dumping to serial port...\n");
    for (size_t i = 0; i < sdt->length; i++)
        com1_write(((uint8_t *)sdt)[i]);
    kprint(KPRN_RAW, "done\n");
}

void debug_prompt(void) {
    kprint(KPRN_RAW, "\nlai_tools debug prompt:\n\n");

    init_com1();

    char prompt[128];
    for (;;) {
        kprint(KPRN_RAW, ">>> ");
        gets(prompt, 128);
        if      (!strcmp(prompt, "dump"))  dump_sdt();
        else    kprint(KPRN_RAW, "invalid command '%s'\n", prompt);
    }
}
