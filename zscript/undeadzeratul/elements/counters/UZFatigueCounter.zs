class UZFatigueCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "fatigueCounter";

		counterIcon   = "";
        counterIconBG = "";
        counterLabel  = Stringtable.Localize("$HHXFatigueCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

    override bool ShouldDrawCounter(HCStatusBar sb, float counterValue) {
        return true;
    }

	override float GetCounterValue(HCStatusBar sb) {
		return sb.hpl.fatigue * 2;
	}
}