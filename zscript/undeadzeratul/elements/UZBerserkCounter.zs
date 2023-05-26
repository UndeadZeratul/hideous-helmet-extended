class UZBerserkCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "berserkCounter";

		counterIcon = "HLMZA0";
		fontColor = Font.CR_RED;
	}

	override int GetCounterValue(HCStatusBar sb) {
		return (sb.hpl.CountInv('HDZerk') - 10500) / 84;
	}
}