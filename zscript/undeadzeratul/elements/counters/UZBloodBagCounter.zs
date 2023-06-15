class UZBloodBagCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "bloodBagCounter";

		counterIcon   = "HLMBA0";
        counterIconBG = "HLMBA1";
        counterLabel  = Stringtable.Localize("$HHXBloodBagCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

    override bool ShouldDrawCounter(HCStatusBar sb, float counterValue) {
        return hd_debug || _alwaysVisible.GetBool() || sb.hpl.FindInventory("BloodBagWorn");
    }

	override float GetCounterValue(HCStatusBar sb) {
		let bloodBag = BloodBagWorn(sb.hpl.FindInventory("BloodBagWorn"));

		return bloodBag ? (bloodBag.bloodLeft * 100 / 256) : 0;
	}

    override string FormatValue(HCStatusBar sb, float counterValue) {
        return String.Format("%i%%", counterValue);
    }
}