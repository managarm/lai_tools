//! expect: (string "Made it past BreakPoint!")

DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI)
        {
            BreakPoint
            Debug = "Made it past BreakPoint!"
        }
    }
}
