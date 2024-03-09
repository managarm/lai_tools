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

        OperationRegion (ID2F, SystemIO, 0xD00, 0x2)
        Field (ID2F, ByteAcc, NoLock, Preserve) {
            IDX2,   4,
            DAT2,   8
        }

        IndexField (IDX2, DAT2, ByteAcc, NoLock, Preserve) {
            RE2A,   8,
            RE2B,   8
        }
 
        Method(_INI)
        {
            //! io-write: pio 8b 0xC00 = 0x2
            //! io-write: pio 8b 0xC01 = 0xAA
            REGC = 0xAA

            //! io-write: pio 8b 0xC00 = 0x0
            //! io-write: pio 8b 0xC01 = 0x55
            REGA = 0x55

            //! io-write: pio 8b 0xC00 = 0x4
            //! io-write: pio 8b 0xC01 = 0xCD

            //! io-write: pio 8b 0xC00 = 0x5
            //! io-write: pio 8b 0xC01 = 0xAB
            REGE = 0xABCD

            //! io-read: pio 8b 0xD00 = 0x00
            //! io-write: pio 8b 0xD00 = 0x01
            //! io-read: pio 8b 0xD00 = 0x01
            //! io-write: pio 8b 0xD00 = 0xA1
            //! io-read: pio 8b 0xD01 = 0x00
            //! io-write: pio 8b 0xD01 = 0x0A
            RE2B = 0xAA
        }
    }
}
