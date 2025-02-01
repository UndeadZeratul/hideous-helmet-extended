class UZStimCounter : BaseCounterHUDElement {

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "stimCounter";

        counterIcon   = "STMCNTR0";
        counterIconBG = "STMCNTR1";
        counterLabel  = Stringtable.Localize("$HHXStimCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override float GetCounterValue(HCStatusbar sb) {
        return sb.hpl.CountInv('HDStim') / 4;
    }

    override string FormatValue(HCStatusbar sb, float counterValue, float maxValue) {
        return String.Format("%i%%", counterValue);
    }
}