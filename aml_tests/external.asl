DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    External(_SB_.FUNC, MethodObj)
    Scope(_SB){
        Method(_INI)
        {
        }

        Method(TEST)
        {
            FUNC()
        }
    }

}
