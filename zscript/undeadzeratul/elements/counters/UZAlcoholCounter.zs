class UZAlcoholCounter : BaseCounterHUDElement {

	Class<Inventory> invClass;

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "alcoholCounter";

		counterIcon   = "HLMUA0";
        counterIconBG = "HLMUA1";
        counterLabel  = Stringtable.Localize("$HHXAlcoholCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");

		string invClassName = "UaSAlcohol_IntoxToken";
		invClass = (Class<Inventory>) (invClassName);
	}

    override bool ShouldDrawCounter(HCStatusBar sb, float counterValue) {
        return invClass && sb.hpl.CountInv(invClass) >= 300;
    }

	override float GetCounterValue(HCStatusBar sb) {
		return invClass ? sb.hpl.CountInv(invClass) / 25000. : 0;
	}

    override string FormatValue(HCStatusBar sb, float counterValue) {
        return String.Format("%.2f%% BAC", counterValue);
    }
}