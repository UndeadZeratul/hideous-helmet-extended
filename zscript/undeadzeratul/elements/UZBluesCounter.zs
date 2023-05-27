class UZBluesCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "bluesCounter";

		counterIcon   = "HLMUA0";
        counterIconBG = "HLMUA1";
        counterLabel  = Stringtable.Localize("$HHXBluesCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

	override float GetCounterValue(HCStatusBar sb) {
		return sb.hpl.CountInv('HealingMagic');
	}
}