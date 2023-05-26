class UZStimCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "stimCounter";

		counterIcon = "HLMSA0";
		fontColor = Font.CR_GREEN;
	}

	override int GetCounterValue(HCStatusBar sb) {
		return sb.hpl.CountInv('HDStim') / 4;
	}
}