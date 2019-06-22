DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
		Name(BUF, Buffer(8){0x12, 0x34, 0x56, 0x78, 0xAB, 0xCD, 0xEF, 0x00})

        Method(_INI, 0, Serialized)
        {
            CreateByteField(BUF, 0, B)
			B = 0
        }
    }
}
