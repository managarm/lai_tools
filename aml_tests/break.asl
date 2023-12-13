DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI) {
            //! expect: (integer 0)
            Local0 = 0 // Loop iterator
            Local1 = 0 // Status checker, should never change
            While (Local0 < 1) {
                Local0 += 1    // Ensure the loop only loops once.

                If (1) {       // This creates a LAI_COND_STACKITEM
                    Break
                    Local1 = 2 // This should never be called.
                }
		Local1 = 1     // This should never be called.
            }

	    Debug = Local1


            // This loops over a while loop a number of times (5), and breaks
            // out of it at a specific point later, not continuing.
            //! expect: (integer 2)
            Local0 = 0 // Loop iterator
            Local1 = 0 // Counter of times reached before Break
            While (Local0 < 5) {
                Local0 += 1
                
                If (Local0 == 3) {
                    Break
                }
                Local1 += 1
            }

            Debug = Local1
        }
    }
}
