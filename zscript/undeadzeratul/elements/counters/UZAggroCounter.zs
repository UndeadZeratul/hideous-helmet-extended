class UZAggroCounter : BaseCounterHUDElement {

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "aggroCounter";

        counterIcon   = "AGRCNTR0";
        counterIconBG = "AGRCNTR1";
        counterLabel  = Stringtable.Localize("$HHXAggroCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override float GetCounterValue(HCStatusBar sb) {
        return sb.hpl.aggravatedDamage;
    }

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {
        return String.Format("%.0f", counterValue);
    }
}