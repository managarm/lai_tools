
DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI)
        {
			NAME(STR, "Foo")
			NAME(BUF, Buffer{0xBE, 0xEF})
			NAME(PKG, Package{0xBE, 0xEF})

			// Index() is supposed to handle names.
			//! (string_index)
			Debug = Index(STR, 0)
			//! (buffer_index)
			Debug = Index(BUF, 0)
			//! (package_index)
			Debug = Index(PKG, 0)

			// Index() is supposed to handle object arguments.
			//! (string_index)
            Debug = Index("Bar", 0)
			//! (buffer_index)
			Debug = Index(Buffer{0xBA, 0xBE}, 0)
			//! (package_index)
			Debug = Index(Package{0xBA, 0xBE}, 0)
        }
    }
}
