
//! (string "Hello world!")

DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI)
        {
			Debug = "Hello world!"
        }
    }
}
