class UZBluesCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "bluesCounter";

		counterIcon   = "BLUCNTR0";
        counterIconBG = "BLUCNTR1";
        counterLabel  = Stringtable.Localize("$HHXBluesCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

	override float GetCounterValue(HCStatusBar sb) {
		return sb.hpl.CountInv('HealingMagic');
	}
}