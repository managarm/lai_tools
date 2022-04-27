
//! expect: (integer 0)

DefinitionBlock("out.aml", "DSDT", 2, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Name(TEST, 0)
        Name(TEST, "Hello There")

        Method(_INI) {
            Debug = TEST
        }
    }
}
