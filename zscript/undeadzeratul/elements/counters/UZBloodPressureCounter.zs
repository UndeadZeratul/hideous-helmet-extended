class UZBloodPressureCounter : BaseCounterHUDElement {

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "bloodPressureCounter";

        counterIcon   = "BPCNTR0";
        counterIconBG = "BPCNTR1";
        counterLabel  = Stringtable.Localize("$HHXBloodPressureCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override float GetCounterValue(HCStatusBar sb) {
        return sb.hpl.bloodPressure;
    }

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {
        return String.Format("%i/%i", (120 + (counterValue / 5.)), (80 + (counterValue / 10.)));
    }
}