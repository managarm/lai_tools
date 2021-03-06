//! expect: (buffer 0x86 0x09 0x00 0x01 0x00 0x00 0x00 0x00 0x00 0x10 0x00 0x00 0x86 0x09 0x00 0x00 0x00 0x20 0x00 0x00 0x00 0x05 0x00 0x00 0x79 0x33)
//! expect: (buffer 0x79 0x87)

DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Name(BUF1, ResourceTemplate(){
            Memory32Fixed(ReadWrite, 0x0, 0x1000)
        })

        Name(BUF2, ResourceTemplate(){
            Memory32Fixed(ReadOnly, 0x2000, 0x500)
        })

        Method(_INI)
        {
			Debug = ConcatenateResTemplate(BUF1, BUF2)
            Debug = ConcatenateResTemplate(Buffer(){}, Buffer(){})
        }
    }
}
