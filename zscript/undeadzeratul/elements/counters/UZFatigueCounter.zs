class UZFatigueCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "fatigueCounter";

		counterIcon   = "";
        counterIconBG = "";
        counterLabel  = Stringtable.Localize("$HHXFatigueCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

	override float GetCounterValue(HCStatusBar sb) {
		return sb.hpl.fatigue * 100 / 30;
	}

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {
        return String.Format("%i%%", counterValue);
    }
}