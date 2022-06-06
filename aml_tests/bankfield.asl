DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        OperationRegion(FOOD, SystemIO, 0xBEEF, 0x4)
        Field(FOOD, AnyAcc, NoLock, Preserve)
        {
            HEYO, 8
        }
        BankField(FOOD, HEYO, 0x55, AnyAcc, NoLock, Preserve)
        {
            DEAD, 8,
            BEEF, 8,
            CAFE, 8,
            BABE, 8,
            TEST, 32,
        }
        Method(_INI)
        {
            //! io-read: pio 8b 0xBEEF = 0x0
            //! io-write: pio 8b 0xBEEF = 0x55
            //! io-read: pio 8b 0xBEF1 = 0x0
            //! io-write: pio 8b 0xBEF1 = 0xAA
            CAFE = 0xAA

            //! io-read: pio 8b 0xBEEF = 0x0
            //! io-write: pio 8b 0xBEEF = 0x55
            //! io-read: pio 8b 0xBEF1 = 0xAA

            //! io-read: pio 8b 0xBEEF = 0x0
            //! io-write: pio 8b 0xBEEF = 0x55
            //! io-read: pio 8b 0xBEF2 = 0
            //! io-write: pio 8b 0xBEF2 = 0xAA
            BABE = CAFE

            //! io-read: pio 8b 0xBEEF = 0x0
            //! io-write: pio 8b 0xBEEF = 0x55
            //! io-read: pio 32b 0xBEF3 = 0x0
            //! io-write: pio 32b 0xBEF3 = 0xBEEFDEAD
            TEST = 0xBEEFDEAD
        }
    }
}
