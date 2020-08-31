#include <kernel.h>
#include <stdint.h>
#include <cio.h>
#include <klib.h>
#include <tty.h>
#include <system.h>
#include <keyboard.h>

#define MAX_CODE 0x57
#define CAPSLOCK 0x3A
#define RIGHT_SHIFT 0x36
#define LEFT_SHIFT 0x2A
#define RIGHT_SHIFT_REL 0xB6
#define LEFT_SHIFT_REL 0xAA
#define CTRL 0x1D
#define CTRL_REL 0x9D

#define KBD_BUF_SIZE 1024

static volatile int    kbd_buffer[KBD_BUF_SIZE];
static volatile size_t kbd_buffer_i = 0;

int getchar(void) {
    while (!kbd_buffer_i)
        asm volatile ("hlt");

    DISABLE_INTERRUPTS;

    int ret = kbd_buffer[0];
    for (size_t i = 1; i < kbd_buffer_i; i++) {
        kbd_buffer[i-1] = kbd_buffer[i];
    }
    kbd_buffer_i--;

    ENABLE_INTERRUPTS;

    return ret;
}

void gets(char *buf, size_t limit) {
    for (size_t i = 0; ; ) {
        char c = getchar();
        switch (c) {
            case '\b':
                if (i) {
                    i--;
                    tty_putchar(c);
                }
                continue;
            case '\n':
                buf[i] = 0;
                tty_putchar(c);
                return;
        }
        if (i < limit-1) {
            buf[i++] = c;
            tty_putchar(c);
        }
    }
}

void keyboard_isr(void);
void init_kbd(void) {
    idt_register_handler(1 + 0x20, 0b10001110, 0, keyboard_isr);
    pic_enable_irq(1);
}

static int capslock_active = 0;
static int shift_active = 0;
static int ctrl_active = 0;

static const uint8_t ascii_capslock[] = {
    '\0', '\e', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\b', '\t',
    'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '[', ']', '\n', '\0', 'A', 'S',
    'D', 'F', 'G', 'H', 'J', 'K', 'L', ';', '\'', '`', '\0', '\\', 'Z', 'X', 'C', 'V',
    'B', 'N', 'M', ',', '.', '/', '\0', '\0', '\0', ' '
};

static const uint8_t ascii_shift[] = {
    '\0', '\e', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '\b', '\t',
    'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', '\n', '\0', 'A', 'S',
    'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', '"', '~', '\0', '|', 'Z', 'X', 'C', 'V',
    'B', 'N', 'M', '<', '>', '?', '\0', '\0', '\0', ' '
};

static const uint8_t ascii_shift_capslock[] = {
    '\0', '\e', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '\b', '\t',
    'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '{', '}', '\n', '\0', 'a', 's',
    'd', 'f', 'g', 'h', 'j', 'k', 'l', ':', '"', '~', '\0', '|', 'z', 'x', 'c', 'v',
    'b', 'n', 'm', '<', '>', '?', '\0', '\0', '\0', ' '
};

static const uint8_t ascii_nomod[] = {
    '\0', '\e', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\b', '\t',
    'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n', '\0', 'a', 's',
    'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`', '\0', '\\', 'z', 'x', 'c', 'v',
    'b', 'n', 'm', ',', '.', '/', '\0', '\0', '\0', ' '
};

static int extra_scancodes = 0;

void keyboard_handler(uint8_t input_byte) {
    uint8_t c;

    if (input_byte == 0xe0) {
        extra_scancodes = 1;
        return;
    }

    if (extra_scancodes) {
        /* extra scancodes */
        extra_scancodes = 0;
        switch (input_byte) {
            case 0x48:
                kbd_buffer[kbd_buffer_i++] = GETCHAR_UP;
                break;
            case 0x4B:
                kbd_buffer[kbd_buffer_i++] = GETCHAR_LEFT;
                break;
            case 0x50:
                kbd_buffer[kbd_buffer_i++] = GETCHAR_DOWN;
                break;
            case 0x4D:
                kbd_buffer[kbd_buffer_i++] = GETCHAR_RIGHT;
                break;
            case 0x49:
                kbd_buffer[kbd_buffer_i++] = GETCHAR_PGUP;
                break;
            case 0x51:
                kbd_buffer[kbd_buffer_i++] = GETCHAR_PGDOWN;
                break;
            case 0x53:
                break;
            case CTRL:
                ctrl_active = 1;
                break;
            case CTRL_REL:
                ctrl_active = 0;
                break;
        }
        return;
    }

    switch (input_byte) {
        case LEFT_SHIFT:
        case RIGHT_SHIFT:
            shift_active = 1;
            return;
        case LEFT_SHIFT_REL:
        case RIGHT_SHIFT_REL:
            shift_active = 0;
            return;
        case CTRL:
            ctrl_active = 1;
            return;
        case CTRL_REL:
            ctrl_active = 0;
            return;
        case CAPSLOCK:
            capslock_active = !capslock_active;
            return;
        default:
            break;
    }

    if (input_byte < MAX_CODE) {

        if (!capslock_active && !shift_active)
            c = ascii_nomod[input_byte];

        else if (!capslock_active && shift_active)
            c = ascii_shift[input_byte];

        else if (capslock_active && shift_active)
            c = ascii_shift_capslock[input_byte];

        else
            c = ascii_capslock[input_byte];

        kbd_buffer[kbd_buffer_i++] = c;

    }

    return;
}
