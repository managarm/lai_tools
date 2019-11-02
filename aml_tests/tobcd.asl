
//! expect: (integer 361617507105)
//! expect: (integer 40925960310)
//! expect: (integer 78187414305)

DefinitionBlock("out.aml", "DSDT", 2, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI)
        {
			Debug = ToBCD(1234512345)
            Debug = ToBCD(6789067890)

            Name(INT0, 1234554321)
            Name(INT1, 0)
            ToBCD(INT0, INT1)

            Debug = INT1
        }
    }
}
