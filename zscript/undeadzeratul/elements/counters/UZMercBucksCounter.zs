class UZMercBucksCounter : BaseCounterHUDElement {

	Class<Inventory> invClass;

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "mercBucksCounter";

		counterIcon   = "MBCKA0";
        counterIconBG = "MBCKA0";
        counterLabel  = Stringtable.Localize("$HHXMercBucksCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");

        string invClassName = "MercenaryBucks";
        invClass = invClassName;
	}

	override float GetCounterValue(HCStatusBar sb) {
		return invClass ? sb.hpl.countInv(invClass) : 0;
	}

    override string FormatValue(HCStatusBar sb, float counterValue) {
        return String.Format("$%i", counterValue);
    }
}