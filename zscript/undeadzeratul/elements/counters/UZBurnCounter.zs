class UZBurnCounter : BaseCounterHUDElement {

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "burnCounter";

        counterIcon   = "BRNCNTR0";
        counterIconBG = "BRNCNTR1";
        counterLabel  = Stringtable.Localize("$HHXBurnCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override float GetCounterValue(HCStatusBar sb) {
        return sb.hpl.burnCount;
    }
}