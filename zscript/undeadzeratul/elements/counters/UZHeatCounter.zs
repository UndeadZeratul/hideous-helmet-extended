class UZHeatCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "heatCounter";

		counterIcon   = "HLMBA0";
        counterIconBG = "HLMBA1";
        counterLabel  = Stringtable.Localize("$HHXHeatCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

	override float GetCounterValue(HCStatusBar sb) {
		let heat = Heat(sb.hpl.FindInventory("Heat"));

		return heat ? heat.realAmount : 0;
	}
}