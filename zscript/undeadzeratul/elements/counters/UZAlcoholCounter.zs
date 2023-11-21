class UZAlcoholCounter : BaseCounterHUDElement {

	Class<Inventory> uasClass;
	Class<Inventory> offworldClass;

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "alcoholCounter";

		counterIcon   = "BACCNTR0";
        counterIconBG = "BACCNTR1";
        counterLabel  = Stringtable.Localize("$HHXAlcoholCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");

		string uasClassName = "UaSAlcohol_IntoxToken";
		uasClass = (Class<Inventory>) (uasClassName);

		string offworldClassName = "UasAlcohol_Offworld_IntoxToken";
		offworldClass = (Class<Inventory>) (offworldClassName);
	}

    override bool ShouldDrawCounter(HCStatusBar sb, float counterValue) {
        return counterValue >= 300;
    }

	override float GetCounterValue(HCStatusBar sb) {
		int uasCount = 0;
		int offworldCount = 0;

		if (uasClass) uasCount += sb.hpl.CountInv(uasClass);
		if (offworldClass) offworldCount += sb.hpl.CountInv(offworldClass);

		return max(uasCount, offworldCount);
	}

	override float GetCounterMaxValue(HCStatusBar sb) {
		return 2500;
	}

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {
        return String.Format("%.2f%% BAC", counterValue / maxValue / 10);
    }
}