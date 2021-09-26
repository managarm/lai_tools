
//! expect: (integer 1)
//! expect: (integer 1)

DefinitionBlock("out.aml", "DSDT", 2, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI)
        {
            Local3 = 0
            For (Local2 = 0, Local2 < 100, Local2++)
            {
                Local0 = Timer()
                Stall(100)
                Local1 = Timer()
                Local3 += (Local1 - Local0) >= 1000 && (Local1 - Local0) <= 1100
            }
            Debug = Local3 >= 90


            Local3 = 0
            For (Local2 = 0, Local2 < 100, Local2++)
            {
                Local0 = Timer()
                Sleep(1)
                Local1 = Timer()
                Local3 += (Local1 - Local0) >= 10000 && (Local1 - Local0) <= 20000
            }
            Debug = Local3 >= 90
        }
    }
}
