
DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(TEST, 1, Serialized) {
            CreateBitField(Arg0, 0, A)
            CreateField(Arg0, 0, 3, C)
            CreateByteField(Arg0, 0, D)
            CreateWordField(Arg0, 0, E)
            CreateDWordField(Arg0, 0, F)
            CreateQWordField(Arg0, 0, G)
        }

        Method(_INI, 0, Serialized)
        {
            Name(BUF, Buffer(8){0x12, 0x34, 0x56, 0x78, 0xAB, 0xCD, 0xEF, 0x00})

            CreateBitField(BUF, 0, BIT)
            CreateField(BUF, 0, 3, BITS)
            CreateByteField(BUF, 0, B)
            CreateWordField(BUF, 0, W)
            CreateDWordField(BUF, 0, DW)
            CreateQWordField(BUF, 0, QW)

            Local0 = BUF
            CreateBitField(Local0, 0, A)
            CreateField(Local0, 0, 3, C)
            CreateByteField(Local0, 0, D)
            CreateWordField(Local0, 0, E)
            CreateDWordField(Local0, 0, F)
            CreateQWordField(Local0, 0, G)

            TEST(BUF)

            // TODO: Test bit fields.

            // TODO: Test that the fields work.
        }
    }
}
