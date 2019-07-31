
//! (string "Hello!")
//! (string "Hello")
//! (string "")
//! (string "Test")
//! (string "Tes")
//! (string "")
//! (string "World")

DefinitionBlock("out.aml", "DSDT", 2, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI)
        {
			Debug = ToString(Buffer(7){0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x21, 0x00})
            Debug = ToString(Buffer(7){0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x21, 0x00}, 5)
            Debug = ToString(Buffer(){})

            Name(STR0, "")
            Name(BUF0, Buffer(5){0x54, 0x65, 0x73, 0x74, 0x00})
            ToString(BUF0, Ones, STR0)
            Debug = STR0

            Name(STR1, "")
            ToString(BUF0, 3, STR1)
            Debug = STR1

            Name(STR2, "")
            Name(BUF1, Buffer(){})
            ToString(BUF1, Ones, STR2)
            Debug = STR2

            Name(STR3, "")
            Name(BUF2, Buffer(){0x57, 0x6F, 0x72, 0x6C, 0x64, 0x0})
            ToString(BUF2, 15, STR3)
            Debug = STR3
        }
    }
}
