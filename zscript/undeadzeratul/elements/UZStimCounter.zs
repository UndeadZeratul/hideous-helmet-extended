class UZStimCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "stimCounter";

		counterIcon   = "HLMSA0";
        counterIconBG = "HLMSA1";
        counterLabel  = Stringtable.Localize("$HHXStimCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

	override float GetCounterValue(HCStatusBar sb) {
		return sb.hpl.CountInv('HDStim') / 4;
	}
}