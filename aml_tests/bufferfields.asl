//! (integer 0)
//! (integer 0x12)
//! (integer 0x3412)
//! (integer 0x78563412)
//! (integer 0x00EFCDAB78563412)

DefinitionBlock("out.aml", "DSDT", 2, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
    	Method(_INI, 0, Serialized)
    	{
    		Name(BUF, Buffer(8){0x12, 0x34, 0x56, 0x78, 0xAB, 0xCD, 0xEF, 0x00})

    		CreateBitField(BUF, 0, BI)
    		CreateByteField(BUF, 0, B)
    		CreateWordField(BUF, 0, W)
    		CreateDWordField(BUF, 0, DW)
    		CreateQWordField(BUF, 0, QW)

			Debug = BI
			Debug = B
			Debug = W
			Debug = DW
			Debug = QW
        }
    }
}
