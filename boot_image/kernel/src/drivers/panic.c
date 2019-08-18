#include <kernel.h>
#include <klib.h>
#include <cio.h>
#include <system.h>
#include <prompt.h>

void panic(const char *msg, int code) {
    DISABLE_INTERRUPTS;
    kprint(KPRN_ERR, "!!! KERNEL PANIC !!!");
    kprint(KPRN_ERR, "Panic info: %s", msg);
    kprint(KPRN_ERR, "Error code: %X", (size_t)code);
    kprint(KPRN_ERR, "Launching debug prompt");
    debug_prompt();
}
