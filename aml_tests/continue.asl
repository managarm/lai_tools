DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(_INI) {
            // This is basically the testcase from #141, except with numbers.
            //! expect: (integer 0)
            Local0 = 0 // Loop iterator
            Local1 = 0 // Status checker, should never change
            While (Local0 < 1) {
                Local0 += 1    // Ensure the loop only loops once.

                If (1) {       // This creates a LAI_COND_STACKITEM
                    Continue
                    Local1 = 2 // This should never be called.
                }
		Local1 = 1     // This should never be called.
            }

	    Debug = Local1


            // This loops over a while loop a number of times (5), and skips it
            // once, continuing afterwards.
            //! expect: (integer 4)
            Local0 = 0 // Loop iterator
            Local1 = 0 // Counter of times reached after Continue
            While (Local0 < 5) {
                Local0 += 1
                
                If (Local0 == 2) {
                    Continue
                }
                Local1 += 1
            }

            Debug = Local1
        }
    }
}
