
//! (integer 42)

DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI)
        {
			Debug = 41 + 1
        }
    }
}
