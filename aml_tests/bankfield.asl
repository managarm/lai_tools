DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        OperationRegion(FOOD, SystemIO, 0xBEEF, 0x4)
        Field(FOOD, AnyAcc, NoLock, Preserve)
        {
            HEYO, 8
        }
        BankField(FOOD, HEYO, 0xDEADBEEF, AnyAcc, NoLock, Preserve)
        {
            DEAD, 8,
            BEEF, 8,
            CAFE, 8,
            BABE, 8,
        }
        Method(_INI)
        {
        }
    }
}
