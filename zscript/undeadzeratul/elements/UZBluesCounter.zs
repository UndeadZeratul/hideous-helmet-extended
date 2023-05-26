class UZBluesCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "bluesCounter";

		counterIcon = "HLMUA0";
		fontColor = Font.CR_LIGHTBLUE;
	}

	override int GetCounterValue(HCStatusBar sb) {
		return sb.hpl.CountInv('HealingMagic');
	}
}