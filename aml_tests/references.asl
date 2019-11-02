
DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        NAME(GLOB, 42)

        Method(_INI)
        {
            LOCAL0 = 42
            LOCAL1 = RefOf(LOCAL0)
            //! expect: (integer 42)
            Debug = DeRefOf(LOCAL1)

            LOCAL0 = "Hello"
            //! expect: (string "Hello")
            Debug = DeRefOf(LOCAL1)

            CopyObject("World", LOCAL0)
            //! expect: (string "World")
            Debug = DeRefOf(LOCAL1)

            LOCAL1 = RefOf(GLOB)
            //! expect: (integer 42)
            Debug = DeRefOf(LOCAL1)

            GLOB = 21
            //! expect: (integer 21)
            Debug = DeRefOf(LOCAL1)

            CopyObject("World", GLOB)
            //! expect: (string "World")
            Debug = DeRefOf(LOCAL1)
        }
    }
}
