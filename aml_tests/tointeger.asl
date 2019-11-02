//! expect: (integer 0x56789E8D)
//! expect: (integer 0x12345678abcdef)
//! expect: (integer 0x5CAB54FF43219216)
//! expect: (integer 5313464)
//! expect: (integer 0x532521abdef)

DefinitionBlock("out.aml", "DSDT", 2, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI)
        {
			Debug = ToInteger(0x56789E8D)
            Debug = ToInteger(0x12345678abcdef)
            Debug = ToInteger(Buffer(3){0x16, 0x92, 0x21, 0x43, 0xFF, 0x54, 0xAB, 0x5C})
            Debug = ToInteger("5313464")
            Debug = ToInteger("0x532521abdef")
        }
    }
}
