
// absd tests
//! expect: (integer 333)
//! expect: (integer 333)

// sqrt tests
//! expect: (integer 12)
//! expect: (integer 5)
//! expect: (integer 3)

// triangle number
//! expect: (integer 1)
//! expect: (integer 6)
//! expect: (integer 1540)
//! expect: (integer 1176)
//! expect: (integer 5050)

// gcd
//! expect: (integer 4)
//! expect: (integer 14)
//! expect: (integer 3)

DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {

        // Calculate absolute difference
        Method(ABSD, 2)
        {
            If(Arg0 > Arg1) 
            {
                Return (Arg0 - Arg1)
            }
            Else 
            {
                Return (Arg1 - Arg0)
            }
        }

        // Calculate square root
        Method(SQRT, 1)
        {   
            If (Arg0 == 0 || Arg0 == 1) 
            {
                Return (Arg0)
            }

            Local0 = 1
            Local1 = 1
            While (Local1 <= Arg0)
            {
                Local0++
                Local1 = Local0 * Local0
            }

            Return (Local0 - 1)
        }

        // Calculate Triangle Number
        Method(TRIG, 1)
        {
            If(Arg0 == 1) 
            {
                Return (1)
            }
            Return (Arg0 + TRIG(Arg0 - 1))
        }

        // greatest common divisor
        Method(GCD, 2)
        {
            If(Arg0 < Arg1) 
            {
                Local0 = Arg0
                Arg0 = Arg1
                Arg1 = Local0
            }

            Local0 = 1
            While(Local0 != 0) 
            {
                Local0 = Arg0 % Arg1
                Arg0 = Arg1
                Arg1 = Local0
            }
            Return (Arg0)
        }

        Method(_INI)
        {
            Debug = ABSD(123, 456)
            Debug = ABSD(456, 123)

            Debug = SQRT(144)
            Debug = SQRT(25)
            Debug = SQRT(9)

            Debug = TRIG(1)
            Debug = TRIG(3)
            Debug = TRIG(55)
            Debug = TRIG(48)
            Debug = TRIG(100)

            Debug = GCD(12, 32)
            Debug = GCD(154,84)
            Debug = GCD(123, 321)
        }
    }
}
