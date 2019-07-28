DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(STOR, 1) {
            ARG0 = 21
        }

        Method(COBJ, 1) {
            CopyObject(21, ARG0)
        }

        Method(_INI) {
            // TODO: Also test loads from ARGx.

            // Test the calling convention for RefOf().
            // RefOf() triggers call-by-reference semantics.

            LOCAL0 = 42
            STOR(RefOf(LOCAL0))
            //! (integer 21)
            Debug = LOCAL0

            LOCAL0 = 42
            COBJ(RefOf(LOCAL0))
            //! (integer 21)
            Debug = LOCAL0

            // Test the calling convention for Index().
            // Index *does not* trigger call-by-reference semantics.

            LOCAL0 = Package(1) { 42 }
            STOR(Index(LOCAL0, 0))
            //! (integer 42)
            Debug = DeRefOf(Index(LOCAL0, 0))

            LOCAL0 = Package(1) { 42 }
            COBJ(Index(LOCAL0, 0))
            //! (integer 42)
            Debug = DeRefOf(Index(LOCAL0, 0))
        }
    }
}
