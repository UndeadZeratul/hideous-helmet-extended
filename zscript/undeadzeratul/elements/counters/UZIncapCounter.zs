class UZIncapCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "incapCounter";

		counterIcon   = "";
        counterIconBG = "";
        counterLabel  = Stringtable.Localize("$HHXIncapCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

	override float GetCounterValue(HCStatusBar sb) {
		return sb.hpl.incapTimer / 35;
	}

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {
		if (countervalue < 60) return String.Format("%02.1f", countervalue);
		else if (countervalue < 3600) return String.Format("%i:%02.1f", countervalue/60, countervalue%60);
		else if (countervalue < 86400) return String.Format("%i:%02i:%02.1f", countervalue/3600, (countervalue%3600)/60, (countervalue%3600)%60);
		else return String.Format("%i:%02i:%02i:%02.1f", countervalue/86400, (countervalue%86400)/3600, ((countervalue%86400)%3600)/60, ((countervalue%86400)%3600)%60);
    }
}