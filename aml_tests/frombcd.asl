
//! expect: (integer 9994321232821798)
//! expect: (integer 4324849018409328)
//! expect: (integer 9850328409332432)

DefinitionBlock("out.aml", "DSDT", 2, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI)
        {
			Debug = FromBCD(0x9994321232821798)
            Debug = FromBCD(0x4324849018409328)

            Name(INT0, 0x9850328409332432)
            Name(INT1, 0)
            FromBCD(INT0, INT1)

            Debug = INT1
        }
    }
}
