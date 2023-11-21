class UZHeartrateCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "heartrateCounter";

		counterIcon   = "HRTCNTR0";
        counterIconBG = "HRTCNTR1";
        counterLabel  = Stringtable.Localize("$HHXHeartrateCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

	override float GetCounterValue(HCStatusBar sb) {
		return sb.hpl.beatMax > 0 ? (2100 / sb.hpl.beatMax) : 0;
	}

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {
        return String.Format("%i BPM", counterValue);
    }
}