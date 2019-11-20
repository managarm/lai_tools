DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        
        OperationRegion (OPRA, SystemIO, 0xA000, 0x0C)
        Field (OPRA, ByteAcc, NoLock, WriteAsZeros)
        {
            FLD1,   3,
            FLD2,   1,
            FLD3,   3,
            FLD4,   9,
        }

        OperationRegion (OPRB, SystemIO, 0xB000, 0x0C)
        Field (OPRB, ByteAcc, NoLock, Preserve)
        {
            FLD5,   3,
            FLD6,   1,
            FLD7,   3,
            FLD8,   9,
        }

        OperationRegion (OPRC, SystemIO, 0xC000, 0x0C)
        Field (OPRC, ByteAcc, NoLock, WriteAsOnes)
        {
            FLD9,   3,
            FLDA,   1,
            FLDB,   3,
            FLDC,   9,
        }

        OperationRegion (GNVS, SystemIO, 0xD018, 0x01D1)
        Field (GNVS, AnyAcc, Lock, Preserve)
        {
            Offset (0xAA),
            ASLA,   16,
            Offset (0xBA),
            ASLB,   32, 
            Offset (0xCB),
            ASLC,   16,
            Offset (0xD0),
            ASLD,   32,
        }

        Method(_INI)
        {
            //! io-read: pio 8b 0xA000 = 0xAC
            //! expect: (integer 4)
            Debug = FLD1
            //! io-read: pio 8b 0xA000 = 0xAC
            //! expect: (integer 1)
            Debug = FLD2
            //! io-read: pio 8b 0xA000 = 0xAC
            //! expect: (integer 2)
            Debug = FLD3
            //! io-read: pio 8b 0xA000 = 0xAC
            //! io-read: pio 8b 0xA001 = 0x55
            //! expect: (integer 0xab)
            Debug = FLD4

            //! io-write: pio 8b 0xA000 = 0x08
            FLD2 = 0x01
            //! io-write: pio 8b 0xA000 = 0x80
            //! io-write: pio 8b 0xA001 = 0xFF
            FLD4 = 0x1FF

            //! io-read: pio 8b 0xB000 = 0xFF
            //! io-write: pio 8b 0xB000 = 0xF7
            FLD6 = 0x00
            //! io-read: pio 8b 0xB000 = 0x55
            //! io-write: pio 8b 0xB000 = 0xD5
            //! io-read: pio 8b 0xB001 = 0x55
            //! io-write: pio 8b 0xB001 = 0xAA
            FLD8 = 0x155

            //! io-write: pio 8b 0xC000 = 0xF7
            FLDA = 0x00
            //! io-write: pio 8b 0xC000 = 0x7F
            //! io-write: pio 8b 0xC001 = 0xFF
            FLDC = 0x1FE

            //! io-read: pio 32b 0xD0D0 = 0xBABE0000
            //! io-read: pio 32b 0xD0D4 = 0x0000CAFE
            //! expect: (integer 0xCAFEBABE)
            Debug = ASLB

            //! io-read: pio 16b 0xD0C2 = 0xCAFE
            //! expect: (integer 0xCAFE)
            Debug = ASLA

            //! io-read: pio 16b 0xD0E2 = 0xBE00
            //! io-read: pio 16b 0xD0E4 = 0x00BA
            //! expect: (integer 0xBABE)
            Debug = ASLC

            //! io-read: pio 32b 0xD0E8 = 0xCAFEBABE
            //! expect: (integer 0xCAFEBABE)
            Debug = ASLD

        }
    }
}
