DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1) {
    Scope(_SB) {
        Device(LNKA) { }
        Device(LNKB) { }
        Device(LNKC) { }
        Device(LNKD) { }
        Device(LNKS) { }

        Method (_PRT, 0, NotSerialized)
        {
            Local0 = Package (0x80) {}
            Local1 = Zero
            While (Local1 < 0x80)
            {
                Local2 = (Local1 >> 0x02)
                Local3 = ((Local1 + Local2) & 0x03)
                If (Local3 == Zero)
                {
                    Local4 = Package (0x04)
                        {
                            Zero, 
                            Zero, 
                            LNKD, 
                            Zero
                        }
                }

                If (Local3 == One)
                {
                    If (Local1 == 0x04)
                    {
                        Local4 = Package (0x04)
                            {
                                Zero, 
                                Zero, 
                                LNKS, 
                                Zero
                            }
                    }
                    Else
                    {
                        Local4 = Package (0x04)
                            {
                                Zero, 
                                Zero, 
                                LNKA, 
                                Zero
                            }
                    }
                }

                If (Local3 == 0x02)
                {
                    Local4 = Package (0x04)
                        {
                            Zero, 
                            Zero, 
                            LNKB, 
                            Zero
                        }
                }

                If (Local3 == 0x03)
                {
                    Local4 = Package (0x04)
                        {
                            Zero, 
                            Zero, 
                            LNKC, 
                            Zero
                        }
                }

                Local4 [Zero] = ((Local2 << 0x10) | 0xFFFF)
                Local4 [One] = (Local1 & 0x03)
                Local0 [Local1] = Local4
                Local1++
            }

            Return (Local0)
        }

        Method(_INI) {
            _PRT()
        }
    }
}
