//! expect: (package (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized))
//! expect: (package (integer 0) (string "hello world") (integer 1) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized) (uninitialized))

DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Name(PKG1, Package(256){
            0x0,
            "hello world",
            0x1
        })

        Method(NUM, 1){
            Return(Add(Arg0, 5))
        }

        Method(_INI)
        {
            Local0 = Package(Add(NUM(0), 1)){}
            Debug = Local0
            Debug = PKG1
        }
    }
}
