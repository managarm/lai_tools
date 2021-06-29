//! expect: (integer 0xFFFFFFFFFFFFFFFF)
//! expect: (integer 0xFFFFFFFFFFFFFFFF)
//! expect: (integer 0xFFFFFFFFFFFFFFFF)

//! expect: (integer 0)
//! expect: (integer 0)
//! expect: (integer 0)

DefinitionBlock("out.aml", "DSDT", 2, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI, 0, Serialized)
        {
            Debug = LEqual(0, 0)
            Debug = LLess(0, 1)
            Debug = LGreater(1, 0)

            Debug = LEqual(1, 0)
            Debug = LLess(1, 0)
            Debug = LGreater(0, 1)
        }
    }
}
