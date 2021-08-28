
//! expect: (string "ello")
//! expect: (buffer 0x6C 0x6C 0x6F 0x21)
//! expect: (buffer )
//! expect: (string "est")
//! expect: (buffer 0x73 0x74 0x00)
//! expect: (string "t")
//! expect: (buffer 0x74)

DefinitionBlock("out.aml", "DSDT", 2, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI)
        {
            Debug = Mid("Hello!", 1, 4)
            Debug = Mid(Buffer(7){0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x21, 0x00}, 2, 4)
            Debug = Mid(Buffer(){}, 0, 0)

            Name(STR0, "")
            Name(STR1, "Test")
            Mid(STR1, 1, 3, STR0)
            Debug = STR0

            Name(BUF0, Buffer(3){})
            Name(BUF1, Buffer(5){0x54, 0x65, 0x73, 0x74, 0x00})
            Mid(BUF1, 2, 3, BUF0)
            Debug = BUF0

            Name(STR2, "")
            Name(STR3, "Test")
            Mid(STR3, 3, 1, STR2)
            Debug = STR2

            Name(BUF2, Buffer(1){})
            Name(BUF3, Buffer(5){0x54, 0x65, 0x73, 0x74, 0x00})
            Mid(BUF3, 3, 1, BUF2)
            Debug = BUF2
        }
    }
}
