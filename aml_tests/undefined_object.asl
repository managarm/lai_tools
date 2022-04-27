//! expect-crash: yes
//! expect: (string "This should print")

DefinitionBlock("out.aml", "DSDT", 2, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI)
        {
            Debug = "This should print"
            TEST = 1
            Debug = "This shouldn't print"
        }
    }
}
