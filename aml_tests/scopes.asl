
//! expect: (integer 3)
//! expect: (integer 0)
//! expect: (integer 4)
//! expect: (integer 3)

DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{

    PowerResource(PCI0, 0x05, 0x0000) {}

    Scope(_SB)
    {
        Scope (\PCI0)
        {
            Name (X, 3)
            Scope (\)
            {
                Method (RQ) {
                    Return (0)
                }
            }
            Name (^Y, 4)
            Alias (X, Z)
        }

        Method(_INI)
        {
            Debug = \PCI0.X
            Debug = \RQ()
            Debug = \Y
            Debug = \PCI0.Z
        }
    }
}
