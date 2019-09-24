
//! (integer 0x0)
//! (integer 0x10)
//! (integer 0x1c)
//! (integer 0x0)
//! (integer 0x07)
//! (integer 0x18)

DefinitionBlock("out.aml", "DSDT", 2, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI)
        {
			Debug = FindSetLeftBit(0)
			Debug = FindSetLeftBit(0xF001)
			NAME(INT0, 0)
			FindSetLeftBit(0x09007001, INT0)
			Debug = INT0

			Debug = FindSetRightBit(0)
			Debug = FindSetRightBit(0x01080040)
			NAME(INT2, 0)
			FindSetRightBit(0x09800000, INT2)
			Debug = INT2
        }
    }
}
