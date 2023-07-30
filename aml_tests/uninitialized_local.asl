//! expect-crash: yes
DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI)
        {
            If((Local0 & 0x1)) {
                Debug = "Test"
            }
        }
    }
}
