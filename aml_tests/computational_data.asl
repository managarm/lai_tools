
//! (integer 0xC1790001)
//! (integer 0x00)
//! (integer 0xFFFFFFFF)
//! (string "12340002")
//! (string "qwrtyu0003")
//! (buffer 0xB0 0xB1 0xB2 0xB3 0xB4)

DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        // numbers
        Name (I32, 0xC1790001)
        Name (IZER, 0x00)
        Name (I32M, 0xFFFFFFFF)

        // strings
        Name (SDIG, "12340002")
        Name (SALN, "qwrtyu0003")

        // buffer
        Name (BUFF, Buffer (0x05)
        {
            0xB0, 0xB1, 0xB2, 0xB3, 0xB4
        })

        Method(_INI)
        {
			Debug = I32
			Debug = IZER
			Debug = I32M
			Debug = SDIG
			Debug = SALN
            Debug = BUFF
        }
    }
}
