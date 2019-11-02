
//! expect: (string "Before Fatal!")
//! expect: (string "After Fatal!")

DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI)
        {
			Debug = "Before Fatal!"
            Fatal(0, 0, 0)
            Debug = "After Fatal!"
        }
    }
}
