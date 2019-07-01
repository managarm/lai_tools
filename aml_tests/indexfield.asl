DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        OperationRegion (SIOR, SystemIO, 0x2E, 0x02)
        Field (SIOR, ByteAcc, NoLock, Preserve)
        {
            SIOI,   8, 
            SIOD,   8
        }
        
        IndexField (SIOI, SIOD, ByteAcc, NoLock, Preserve)
        {
            FLPT,   1, 
            FCMA,   1, 
            FCMB,   1, 
            FDCA,   1, 
            Offset (0x01), 
            Offset (0x04), 
            PEPP,   1, 
            Offset (0x05), 
            Offset (0x1B), 
            ,   4, 
            PPIR,   4, 
            CAIR,   4, 
            CBIR,   4, 
            Offset (0x41), 
            FCIR,   4, 
            CDMA,   3, 
            Offset (0x42), 
            PBAL,   8, 
            PBAH,   8, 
            S1BL,   8, 
            S1BH,   8, 
            S2BL,   8, 
            S2BH,   8, 
            FBAL,   8, 
            FBAH,   8
        }

        Method(_INI)
        {
        }
    }
}
