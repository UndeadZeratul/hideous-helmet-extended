class UZBloodLossCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "bloodlossCounter";

		counterIcon   = "";
        counterIconBG = "";
        counterLabel  = Stringtable.Localize("$HHXBloodLossCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

	override float GetCounterValue(HCStatusBar sb) {
		return sb.hpl.bloodLoss / 1024.;
	}

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {
        return String.Format("%.2f", counterValue)..StringTable.Localize("$MEDIKIT_TRANSFUSIONUNITS");
    }
}