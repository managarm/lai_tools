
DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        NAME(GLOB, 42)

        Method(_INI)
        {
            LOCAL0 = 42
            LOCAL1 = RefOf(LOCAL0)
            //! (integer 42)
            Debug = DeRefOf(LOCAL1)

            LOCAL0 = "Hello"
            //! (string "Hello")
            Debug = DeRefOf(LOCAL1)

            CopyObject("World", LOCAL0)
            //! (string "World")
            Debug = DeRefOf(LOCAL1)

            LOCAL1 = RefOf(GLOB)
            //! (integer 42)
            Debug = DeRefOf(LOCAL1)

            GLOB = 21
            //! (integer 21)
            Debug = DeRefOf(LOCAL1)

            CopyObject("World", GLOB)
            //! (string "World")
            Debug = DeRefOf(LOCAL1)
        }
    }
}
