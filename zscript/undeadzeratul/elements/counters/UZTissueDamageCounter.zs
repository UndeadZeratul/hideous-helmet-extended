class UZTissueDamageCounter : BaseCounterHUDElement {

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "tissueDamageCounter";

        counterIcon   = "TDMCNTR0";
        counterIconBG = "TDMCNTR1";
        counterLabel  = Stringtable.Localize("$HHXTissueDamageCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override float GetCounterValue(HCStatusBar sb) {
        return sb.hpl.oldWoundCount;
    }

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {
        return String.Format("%.0f", counterValue);
    }
}