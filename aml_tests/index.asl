DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1) {
    Scope(_SB) {
        Method(_INI) {
            NAME(STR, "Foo")
            NAME(BUF, Buffer(2){0xBE, 0xEF})
            NAME(PKG, Package(2){0xBE, 0xEF})

            // Index() is supposed to handle names.

            //! expect: (string_index)
            Debug = Index(STR, 0)
            //! expect: (buffer_index)
            Debug = Index(BUF, 0)
            //! expect: (package_index)
            Debug = Index(PKG, 0)

            // Index() is supposed to handle object arguments.

            //! expect: (string_index)
            Debug = Index("Bar", 0)
            //! expect: (buffer_index)
            Debug = Index(Buffer(2){0xBA, 0xBE}, 0)
            //! expect: (package_index)
            Debug = Index(Package(2){0xBA, 0xBE}, 0)

            // Indices remain valid if objects are mutated.

            //! expect: (integer 66)
            LOCAL0 = Index(STR, 0)
            STR = "Baz"
            Debug = DeRefOf(LOCAL0)

            //! expect: (integer 0x12)
            LOCAL0 = Index(BUF, 0)
            BUF = Buffer(2){0x12, 0x34}
            Debug = DeRefOf(LOCAL0)

            //! expect: (integer 0x12)
            LOCAL0 = Index(PKG, 0)
            PKG = Package(2){0x12, 0x34}
            Debug = DeRefOf(LOCAL0)

            // But CopyObject() does not mutate objects.

            STR = "Foo"
            BUF = Buffer(2){0xBE, 0xEF}
            PKG = Package(2){0xBE, 0xEF}

            //! expect: (integer 70)
            LOCAL0 = Index(STR, 0)
            CopyObject("Baz", STR);
            Debug = DeRefOf(LOCAL0)

            //! expect: (integer 0xBE)
            LOCAL0 = Index(BUF, 0)
            CopyObject(Buffer(2){0x12, 0x34}, BUF)
            Debug = DeRefOf(LOCAL0)

            //! expect: (integer 0xBE)
            LOCAL0 = Index(PKG, 0)
            CopyObject(Package(2){0x12, 0x34}, PKG)
            Debug = DeRefOf(LOCAL0)
        }
    }
}
