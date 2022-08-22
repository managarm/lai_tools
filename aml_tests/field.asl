DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        
        OperationRegion (PRST, SystemIO, 0xAF00, 0x0C)
        Field (PRST, ByteAcc, NoLock, WriteAsZeros)
        {
            Offset (0x04), 
            CPEN,   1, 
            CINS,   1, 
            CRMV,   1, 
            CEJ0,   1, 
            Offset (0x05), 
            CCMD,   8,
            CDAT,  16,
        }

        Method(_INI)
        {
            //! io-read: pio 8b 0xAF05 = 0xAB
            //! expect: (integer 0xAB)
            Debug = CCMD

            //! io-write: pio 8b 0xAF05 = 0x55
            CCMD = 0x55

            //! io-write: pio 8b 0xAF05 = 0x48
            //               'H' in ASCII ^
            CCMD = "Hello World"

            //! io-write: pio 8b 0xAF06 = 0x4C
            //               'L' in ASCII ^
            //! io-write: pio 8b 0xAF07 = 0x41
            //               'A' in ASCII ^
            CDAT = "LAI"
        }
    }
}
