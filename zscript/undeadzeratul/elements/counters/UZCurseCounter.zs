class UZCurseCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "curseCounter";

		counterIcon   = "HLMZA0";
        counterIconBG = "HLMZA1";
        counterLabel  = Stringtable.Localize("$HHXCurseCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

	override float GetCounterValue(HCStatusBar sb) {
		let value = 0;

		// Count all the active curses
		let iter = ThinkerIterator.create("NecromancerGhost");
		while(iter.next()) value++;

		return value;
	}
}