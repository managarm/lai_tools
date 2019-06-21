
//! (package (uninitialized))
//! (package (integer 2882338820) (string "12340002") (buffer 74 65 73 74))
//! (package (package (integer 2882338820) (string "12340002") (buffer 74 65 73 74)) (package (uninitialized)))

DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        // numbers
        Name (I32, 0xC1790001)
        Name (IZER, 0x00)
        Name (I32M, 0xFFFFFFFF)

        // strings
        Name (SDIG, "12340002")
        Name (SALN, "qwrtyu0003")

        // buffer
        Name (BUFF, Buffer (0x05)
        {
            0xB0, 0xB1, 0xB2, 0xB3, 0xB4
        })

        // uninitialized package elements
        Name (PKGE, Package (0x01){})

        // package elements
        Name (PKGD, Package (0x03)
        {   
            0xABCD0004,
            "test",
            Buffer(0x04) 
            {
                0xAA, 0xBB, 0xCC, 0xDD
            }
        })

        Name (PKGN, Package (0x02)
        {
            Package (0x03)
            {   
                0xABCD0004,
                "test",
                Buffer(0x04) 
                {
                    0xAA, 0xBB, 0xCC, 0xDD
                }
            },
            Package (0x01){}
        })

        Method(_INI)
        {
            Debug = PKGE
            Debug = PKGD
            Debug = PKGN
        }
    }
}
