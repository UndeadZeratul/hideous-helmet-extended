class UZFireDouseCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "fireDouseCounter";

		counterIcon   = "HLMUA0";
        counterIconBG = "HLMUA1";
        counterLabel  = Stringtable.Localize("$HHXFireDouseCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

	override float GetCounterValue(HCStatusBar sb) {
		return sb.hpl.CountInv('HDFireDouse') * 5;
	}

    override string FormatValue(HCStatusBar sb, float counterValue) {
        return String.Format("%i%%", counterValue)..(sb.hpl.vel dot sb.hpl.vel > 4 ? " +60%" : "");
    }
}