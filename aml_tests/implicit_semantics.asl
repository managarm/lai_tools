DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1) {
    Scope(_SB) {
        Name(STR, "123")
        Name(BUF, Buffer(3) {1, 2, 3})
        Name(PKG, Package(3) {1, 2, 3})

        Method(_INI) {
            // Implicit conversion can grow and shrink strings and packags.

            LOCAL0 = RefOf(STR)
            LOCAL1 = RefOf(BUF)
            LOCAL2 = RefOf(PKG)

            STR = "1234567890ABCDEF"
            //! expect: (string "1234567890ABCDEF")
            Debug = DeRefOf(LOCAL0)

            BUF = Buffer(16) {6, 5, 4, 3, 2, 1}
            //! expect: (buffer 6 5 4)
            Debug = DeRefOf(LOCAL1)

            PKG = Package(6) {1, 2, 3, 4, 5, 6}
            //! expect: (package (integer 1) (integer 2) (integer 3) (integer 4) (integer 5) (integer 6))
            Debug = DeRefOf(LOCAL2)

            STR = "1"
            //! expect: (string "1")
            Debug = DeRefOf(LOCAL0)

            BUF = Buffer(16) {1}
            //! expect: (buffer 1 0 0)
            Debug = DeRefOf(LOCAL1)

            PKG = Package(1) {1}
            //! expect: (package (integer 1))
            Debug = DeRefOf(LOCAL2)
        }
    }
}
