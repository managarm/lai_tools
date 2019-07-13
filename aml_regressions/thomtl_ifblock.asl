DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
        Method (MIN, 2, NotSerialized)
        {
            If ((Arg0 < Arg1))
            {
                Return (Arg0)
            }
            Else
            {
                Return (Arg1)
            }
        }

        Method (SLEN, 1, NotSerialized)
        {
            Local0 = Arg0
            Return (SizeOf (Local0))
        }

        Method (S2BF, 1, NotSerialized)
        {
            Local0 = Arg0
            Local0 = (SLEN (Local0) + One)
            Name (BUFF, Buffer (Local0){})
            BUFF = Arg0
            Return (BUFF) /* \_SB_.S2BF.BUFF */
        }

        Method (SCMP, 2, NotSerialized)
        {
            Local0 = Arg0
            Local0 = S2BF (Local0)
            Local1 = S2BF (Arg1)
            Local4 = Zero
            Local5 = SLEN (Arg0)
            Local6 = SLEN (Arg1)
            Local7 = MIN (Local5, Local6)
            While ((Local4 < Local7))
            {
                Local2 = DerefOf (Local0 [Local4])
                Local3 = DerefOf (Local1 [Local4])
                If ((Local2 > Local3))
                {
                    Return (One)
                }
                ElseIf ((Local2 < Local3))
                {
                    Return (Ones)
                }

                Local4++
            }

            If ((Local4 < Local5))
            {
                Return (One)
            }
            ElseIf ((Local4 < Local6))
            {
                Return (Ones)
            }
            Else
            {
                Return (Zero)
            }
        }

        Name (TOOS, 0x00)
        Method (_INI, 0, NotSerialized)
        {
            If (CondRefOf (_OSI, Local0))
            {
                If (\_OSI ("Windows 2001"))
                {
                    TOOS = 0x05
                }

                If (\_OSI ("Windows 2001.1"))
                {
                    TOOS = 0x06
                }

                If (\_OSI ("Windows 2001.1 SP1"))
                {
                    TOOS = 0x07
                }

                If (\_OSI ("Windows 2006"))
                {
                    TOOS = 0x08
                }

                If (\_OSI ("Windows 2006.1"))
                {
                    TOOS = 0x08
                }

                If (\_OSI ("Linux"))
                {
                    TOOS = 0x01
                }
            }
            Else
            {
                Local0 = \_OS
                Local1 = SCMP (Local0, "Microsoft Windows NT")
                If (~Local1)
                {
                    TOOS = 0x04
                }
                Else
                {
                    Local2 = SCMP (Local0, "Microsoft Windows")
                    If (~Local2)
                    {
                        TOOS = 0x02
                    }
                    Else
                    {
                        Local3 = SCMP (Local0, "Microsoft WindowsME:Millennium Edition")
                        If (~Local3)
                        {
                            TOOS = 0x03
                        }
                    }
                }
            }
        }
    }
}
