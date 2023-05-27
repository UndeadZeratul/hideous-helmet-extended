class UZBerserkCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "berserkCounter";

		counterIcon   = "HLMZA0";
        counterIconBG = "HLMZA1";
        counterLabel  = Stringtable.Localize("$HHXBerserkCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

	override float GetCounterValue(HCStatusBar sb) {
		return (sb.hpl.CountInv('HDZerk') - 10500) / 84;
	}
}