
//! (integer 3)
//! (integer 0)
//! (integer 4)

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
        }
        
        Method(_INI)
        {
            Debug = \PCI0.X
            Debug = \RQ()
            Debug = \Y
        }
    }
}
