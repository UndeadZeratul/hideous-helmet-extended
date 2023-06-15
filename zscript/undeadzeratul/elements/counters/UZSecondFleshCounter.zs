class UZSecondFleshCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "secondFleshCounter";

		counterIcon   = "HLMUA0";
        counterIconBG = "HLMUA1";
        counterLabel  = Stringtable.Localize("$HHXSecondFleshCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

	override float GetCounterValue(HCStatusBar sb) {
		return sb.hpl.CountInv('SecondFlesh');
	}
}