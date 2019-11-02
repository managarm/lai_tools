
//! expect: (package (uninitialized))
//! expect: (package (integer 0xABCD0004) (string "test") (buffer 0xAA 0xBB 0xCC 0xDD))
//! expect: (package (package (integer 0xABCD0004) (string "test") (buffer 0xAA 0xBB 0xCC 0xDD)) (package (uninitialized)))

DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
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
