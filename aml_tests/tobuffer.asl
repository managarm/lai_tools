
//! expect: (buffer 0x48 0x65 0x6C 0x6C 0x6F 0x21 0x00)
//          Translates to "Hello!", with the implicit '\0' added
//! expect: (buffer )
//          Empty buffer but should work
//! expect: (buffer 0x21 0xFF 0x56 0x78 0x7F 0x99 0x65 0x45)
//! expect: (buffer 0xAA 0xBB 0xCC 0xDD 0xEE 0xFF)

//! expect: (buffer 0x54 0x65 0x73 0x74 0x00)
//          Translates to "Test", with the implicit '\0' added
//! expect: (buffer)
//! expect: (buffer 0xAA 0xBB 0xCC 0xDD 0xEE 0xFF 0x12 0x34)
//! expect: (buffer 0x86 0x43 0x89 0x56 0x06 0x34 0x28 0x83 0x90)

DefinitionBlock("out.aml", "DSDT", 2, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI)
        {
			Debug = ToBuffer("Hello!")
            Debug = ToBuffer("")
            Debug = ToBuffer(0x4565997F7856FF21)
            Debug = ToBuffer(Buffer(6){0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF})

            Name(STRT, "Test") // STRTest
            Name(BUF0, Buffer(5){})
            ToBuffer(STRT, BUF0)
            Debug = BUF0

            Name(NULT, "") //Empty String Test
            Name(BUF1, Buffer(10){})
            ToBuffer(NULT, BUF1)
            Debug = BUF1

            Name(INTT, 0x3412FFEEDDCCBBAA) //INTTest
            Name(BUF2, Buffer(8){})
            ToBuffer(INTT, BUF2)
            Debug = BUF2

            Name(BUFT, Buffer(9){0x86, 0x43, 0x89, 0x56, 0x06, 0x34, 0x28, 0x83, 0x90})
            Name(BUF3, Buffer(9){})
            ToBuffer(BUFT, BUF3)
            Debug = BUF3
        }
    }
}
