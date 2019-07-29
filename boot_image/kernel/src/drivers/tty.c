#include <tty.h>
#include <vga_textmode.h>

void tty_putchar(char c) {
    text_putchar(c);
}
