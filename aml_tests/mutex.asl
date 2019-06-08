
DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Mutex(MUTX, 0)
        Method(_INI)
        {
            Acquire(MUTX, 0)
            Release(MUTX)
        }
    }
}
