#include <keyboard.h>
#include <klib.h>

void debug_prompt(void) {
    kprint(KPRN_RAW, "\nlai_tools debug prompt:\n\n");

    char prompt[256];
    for (;;) {
        kprint(KPRN_RAW, ">>> ");
        gets(prompt, 256);
        kprint(KPRN_RAW, "%s\n", prompt);
    }
}
