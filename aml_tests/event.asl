DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1) {
    Scope(_SB) {
        Event(EVT)
        Method(_INI) {
            Signal(EVT)
            Wait(EVT, 0xFFFF)
            Reset(EVT)
        }
    }
}
