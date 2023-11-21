class UZFireDouseCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "fireDouseCounter";

		counterIcon   = "FDSCNTR0";
        counterIconBG = "FDSCNTR1";
        counterLabel  = Stringtable.Localize("$HHXFireDouseCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

	override float GetCounterValue(HCStatusBar sb) {
		return sb.hpl.CountInv('HDFireDouse') * 5;
	}

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {
        return String.Format("%i%%", counterValue)..(sb.hpl.vel dot sb.hpl.vel > 4 ? " +60%" : "");
    }
}