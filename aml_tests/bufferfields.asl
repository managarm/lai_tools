
DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI, 0, Serialized)
        {
            Name(BUF, Buffer(8){0x12, 0x34, 0x56, 0x78, 0xAB, 0xCD, 0xEF, 0x00})

            CreateBitField(BUF, 0, BIT)
            CreateField(BUF, 0, 3, BITS)
            CreateByteField(BUF, 0, B)
            CreateWordField(BUF, 0, W)
            CreateDWordField(BUF, 0, DW)
            CreateQWordField(BUF, 0, QW)

            // TODO: Test bit fields.

            // TODO: Test that the fields work.
        }
    }
}
