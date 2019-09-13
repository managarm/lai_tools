// Strings
// Buffer -> String
//! (string "")
//! (string "0xAB 0xEC 0xFE 0x3D 0x5E 0x9B")
// Integer -> String
//! (string "ABCDEF1234567890")
//! (string "000000000000ABCE")

// Buffers
// String -> Buffer
//! (buffer 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
//! (buffer 0x4C 0x41 0x49 0x20 0x69 0x73 0x20 0x76 0x65 0x72 0x79 0x20 0x63 0x6F 0x6F 0x6C 0x00 0 0 0)
// Integer -> Buffer
//! (buffer 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0 0 0 0 0 0 0 0 0 0 0 0)
//! (buffer 0x21 0xFF 0x56 0x78 0x7F 0x99 0x65 0x45 0 0 0 0 0 0 0 0 0 0 0 0)

// Integers
// String -> Integer
//! (integer 0xABCDEF0213)
//! (integer 0x144839257)
//! (integer 0x1234567894328494)

// Buffer -> Integer
//! (integer 0x3412)
//! (integer 0xFEDCBA0987654321)

DefinitionBlock("out.aml", "DSDT", 2, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method(STR_)
        {
            // Strings
            Name(STR0, "Hello World!")

            // Buffer -> String
            Name(BUF0, Buffer(0){})
            Store(BUF0, STR0)
			Debug = STR0

            Name(BUF1, Buffer(6){0xAB, 0xEC, 0xFE, 0x3D, 0x5E, 0x9B})
            Store(BUF1, STR0)
            Debug = STR0

            // Integer -> String
            Name(INT0, 0xABCDEF1234567890)
            Store(INT0, STR0)
            Debug = STR0

            Name(INT1, 0xABCE)
            Store(INT1, STR0)
            Debug = STR0
        }

        Method(BUF_)
        {
            // Buffers
            Name(BUF0, Buffer(20){}) // Has to be big since everything gets truncated

            // String -> Buffer
            Name(STR0, "")
            Store(STR0, BUF0)
            Debug = BUF0

            Name(STR1, "LAI is very cool")
            Store(STR1, BUF0)
            Debug = BUF0

            // Integer -> Buffer
            Name(INT0, 0)
            Store(INT0, BUF0)
            Debug = BUF0

            Name(INT1, 0x4565997F7856FF21)
            Store(INT1, BUF0)
            Debug = BUF0
        }

        Method(INT_)
        {
            // Integers
            Name(INT0, 0x943289)

            // String -> Integer
            Name(STR0, "ABCDef0213xjz")
            Store(STR0, INT0)
            Debug = INT0

            Name(STR1, "144839257")
            Store(STR1, INT0)
            Debug = INT0

            Name(STR2, "1234567894328494fffffff")
            Store(STR2, INT0)
            Debug = INT0

            // Buffer -> Integer
            Name(BUF0, Buffer(2){0x12,0x34})
            Store(BUF0, INT0)
            Debug = INT0

            Name(BUF1, Buffer(8){0x21, 0x43, 0x65, 0x87, 0x09, 0xBA, 0xDC, 0xFE})  
            Store(BUF1, INT0)
            Debug = INT0            
        }

        Method(_INI)
        {
            STR_()
            BUF_()
            INT_()
        }
    }
}
