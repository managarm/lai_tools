//! expect: (integer 0xFFFFFFFFFFFFFFFF)
//! expect: (integer 0xFFFFFFFFFFFFFFFF)
//! expect: (integer 0xFFFFFFFFFFFFFFFF)

//! expect: (integer 0)
//! expect: (integer 0)
//! expect: (integer 0)

//! expect: (integer 0)
//! expect: (integer 0xFFFFFFFFFFFFFFFF)
//! expect: (integer 0)
//! expect: (integer 0)

//! expect: (integer 0)
//! expect: (integer 0xFFFFFFFFFFFFFFFF)
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

            Debug = "123" == "456"
            Debug = "123" == "123"
            Debug = "123456" == "123"
            Debug = "123" == "123456"

            Debug = Buffer() { 0, 1, 2 } == Buffer() { 4, 5, 6 }
            Debug = Buffer() { 0, 1, 2 } == Buffer() { 0, 1, 2 }
            Debug = Buffer() { 0, 1, 2, 3, 4, 5 } == Buffer() { 0, 1, 2 }
            Debug = Buffer() { 0, 1, 2 } == Buffer() { 0, 1, 2, 3, 4, 5 }

        }
    }
}
