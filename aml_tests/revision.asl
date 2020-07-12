DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
	Scope(_SB)
	{
		Method(_INI)
		{
			Local1 = Revision

			//! expect: (string "Made it past RevisionOp!")
			Debug = "Made it past RevisionOp!"
		}
	}
}
