DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Name (DATA, Package (0x16)
        {
            One,
            0x02,
            0x03,
            Zero,
        })

        Method(FOO, 1)
        {
            // This line caused a use-after-free in commit fdf3c4d3.
            Return (DerefOf (DATA[Arg0]))
        }

        Method(_INI)
        {
            //! (integer 2)
            Debug = FOO (1)
        }
    }
}
