//! expect: (integer 0)
//! expect: (integer 0x100)
//! expect: (integer 6)

//! expect: (integer 1)
//! expect: (integer 0x200)
//! expect: (integer 6)

DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Processor(CPU0, 0, 0x100, 6) 
        {
            Method(CPID) // These functions are not defined by the ACPI spec but by me to test since i cant directly access the data encoded in the Processor object
            {
                Return (0)
            }
            Method(PADR)
            {
                Return (0x100)
            }
            Method(PLEN)
            {
                Return (6)
            }
        }
        Processor(CPU1, 1, 0x200, 6)
        {
            Method(CPID)
            {
                Return (1)
            }
            Method(PADR)
            {
                Return (0x200)
            }
            Method(PLEN)
            {
                Return (6)
            }
        }

        Method(_INI)
        {
            Debug = ^CPU0.CPID()
            Debug = ^CPU0.PADR()
            Debug = ^CPU0.PLEN()

            Debug = ^CPU1.CPID()
            Debug = ^CPU1.PADR()
            Debug = ^CPU1.PLEN()
        }
    }
}
