class UZMercBucksCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "mercBucksCounter";

		counterIcon   = "MBCKA0";
        counterIconBG = "MBCKA0";
        counterLabel  = Stringtable.Localize("$HHXMercBucksCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

	override float GetCounterValue(HCStatusBar sb) {
        string cls = "MercenaryBucks";
        Class<Inventory> bux = cls;
		return bux ? sb.hpl.countInv(bux) : 0;
	}

    override string FormatValue(HCStatusBar sb, float counterValue) {
        return String.Format("$%i", counterValue);
    }
}