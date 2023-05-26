class UZBloodBagCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "bloodBagCounter";

		counterIcon = "HLMBA0";
		fontColor = Font.CR_RED;
	}

	override int GetCounterValue(HCStatusBar sb) {
		let bloodBag = BloodBagWorn(sb.hpl.FindInventory("BloodBagWorn"));

		return bloodBag ? bloodBag.bloodLeft : 0;
	}
}