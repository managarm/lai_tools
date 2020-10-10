//! expect: (string "0x56,0x78,0x9E,0x8D")
//! expect: (string "0x54,0xAB,0x5C")
//! expect: (string "0xFF,0x6E,0x6F,0xF4")
//! expect: (string "0x26,0x84,0x01,0x37")
//! expect: (string "ABCDEF01")

DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI)
        {
			Debug = ToHexString(Buffer(4){0x56, 0x78, 0x9E, 0x8D})
            Debug = ToHexString("0x54,0xAB,0x5C")

            Name(STR0, "")
            Name(BUF0, Buffer(4){0xFF, 0x6E, 0x6F, 0xF4})
            ToHexString(BUF0, STR0)
            Debug = STR0

            Name(STR1, "")
            Name(STR2, "0x26,0x84,0x01,0x37")
            ToHexString(STR2, STR1)
            Debug = STR1

            Name(STR3, "")
            Name(INT0, 0xABCDEF01)
            ToHexString(INT0, STR3)
            Debug = STR3
        }
    }
}
