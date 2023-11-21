class UZFragCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "fragCounter";

		counterIcon   = "FRGCNTR0";
        counterIconBG = "FRGCNTR1";
        counterLabel  = Stringtable.Localize("$HHXFragCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

	override float GetCounterValue(HCStatusBar sb) {
		let value = 0;

		// Count all the current Frag Shards
		let iter = ThinkerIterator.create("BFGNecroShard");
		while(iter.next()) value++;

		return value;
	}
}