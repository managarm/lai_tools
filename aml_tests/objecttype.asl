
DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
       
        Name(INT0, 0x00)
        Alias(INT0, ALI0)
        Alias(ALI0, ALI1)
        Name(STR0, "Hello World")
        Name(BUF0, Buffer(5){0xFF, 0xFF, 0xFF, 0xFF, 0xFF})
        Mutex(MUTX, 0)
        Method(_INI)
        {
            //! (integer 1)
            Debug = ObjectType(INT0)
            //! (integer 2)
            Debug = ObjectType(STR0)
            //! (integer 3)
            Debug = ObjectType(BUF0)
            //! (integer 9)
            Debug = ObjectType(MUTX)
            //! (integer 16)
            Debug = ObjectType(Debug)

            //! (integer 1)
            Debug = ObjectType(ALI0)

            //! (integer 1)
            Debug = ObjectType(ALI1)

            //! (integer 1)
            Debug = ObjectType(RefOf(INT0))

            //! (integer 2)
            Arg1 = STR0
            Debug = ObjectType(Arg1)

            //! (integer 3)
            Local0 = BUF0
            Debug = ObjectType(Local0)

            // See note in source code (at time of writing exec.c line: 735)
            //! (integer 6)
            Debug = ObjectType(\_SB_)
        }
    }
}
