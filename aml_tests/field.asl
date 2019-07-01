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
            CCMD,   8
        }

        Method(_INI)
        {
        }
    }
}
