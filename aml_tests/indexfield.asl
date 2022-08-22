DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        OperationRegion (IDXF, SystemIO, 0xC00, 0x2)
        Field (IDXF, ByteAcc, NoLock, Preserve) {
            IDX,   8, 
            DAT,   8
        }
 
        IndexField (IDX, DAT, ByteAcc, NoLock, Preserve) {
            REGA,   8, 
            REGB,   8, 
            REGC,   8, 
            REGD,   8, 
            REGE,  16,
        }
 
        Method(_INI)
        {
            //! io-read: pio 8b 0xC00 = 0x0
            //! io-write: pio 8b 0xC00 = 0x2
            //! io-read: pio 8b 0xC01 = 0x0

            //! io-read: pio 8b 0xC00 = 0x0
            //! io-write: pio 8b 0xC00 = 0x2
            //! io-read: pio 8b 0xC01 = 0x0
            //! io-write: pio 8b 0xC01 = 0xAA
            REGC = 0xAA

            //! io-read: pio 8b 0xC00 = 0x0
            //! io-write: pio 8b 0xC00 = 0x0
            //! io-read: pio 8b 0xC01 = 0x0

            //! io-read: pio 8b 0xC00 = 0x0
            //! io-write: pio 8b 0xC00 = 0x0
            //! io-read: pio 8b 0xC01 = 0x0
            //! io-write: pio 8b 0xC01 = 0x55
            REGA = 0x55

            //! io-read: pio 8b 0xC00 = 0x0
            //! io-write: pio 8b 0xC00 = 0x4
            //! io-read: pio 8b 0xC01 = 0x0

            //! io-read: pio 8b 0xC00 = 0x0
            //! io-write: pio 8b 0xC00 = 0x4
            //! io-read: pio 8b 0xC01 = 0x0
            //! io-write: pio 8b 0xC01 = 0xCD

            //! io-read: pio 8b 0xC00 = 0x0
            //! io-write: pio 8b 0xC00 = 0x5
            //! io-read: pio 8b 0xC01 = 0x0

            //! io-read: pio 8b 0xC00 = 0x0
            //! io-write: pio 8b 0xC00 = 0x5
            //! io-read: pio 8b 0xC01 = 0x0
            //! io-write: pio 8b 0xC01 = 0xAB
            REGE = 0xABCD
        }
    }
}