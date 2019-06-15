
DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB) 
    {

        PowerResource(WRST, 0x05, 0x0000)
        {
            Method (_STA, 0, NotSerialized)
            {
                Return (Zero)
            }

            Method (_ON, 0, NotSerialized)
            {
                Return (Zero)
            }

            Method (_OFF, 0, NotSerialized)
            {
                Return (Zero)
            }

            Method (_RST, 0, NotSerialized)
            {
                Return (Zero)
            }
        }

        Method(_INI)
        {
        }
    }
}
