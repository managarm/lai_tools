DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
    Scope(_SB)
    {
		OperationRegion (LPCS, SystemMemory, 0, 0x0500)
		Device (HPET) {
			Name(_ADR, 0)
			Field (\_SB.LPCS, DWordAcc, Lock, Preserve) {
				Offset (0x328),
				HBAS,   32
			}
		}

        Method(_INI, 0, Serialized)
        {
        }
    }
}
