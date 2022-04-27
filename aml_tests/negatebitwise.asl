//! expect: (integer 0xfffffffffffffffd)
//! expect: (integer 0xfffffffffffffffd)
//! expect: (integer 0xffffffffffffffd1)
//! expect: (integer 0xffffffffffffffd1)


DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
	Scope(_SB)
	{
		Method(_INI)
		{
			Debug = Nand(10, 38, Local0)
			Debug = Local0

			Debug = Nor(10, 38, Local0)
			Debug = Local0
		}
	}
}
