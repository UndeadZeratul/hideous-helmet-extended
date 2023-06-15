class UZBerserkCooldownCounter : BaseCounterHUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "berserkCooldownCounter";

		counterIcon   = "HLMZA0";
        counterIconBG = "HLMZA1";
        counterLabel  = Stringtable.Localize("$HHXBerserkCooldownCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
	}

    override bool ShouldDrawCounter(HCStatusBar sb, float counterValue) {
        return counterValue > 0 && counterValue <= 10500;
    }

	override float GetCounterValue(HCStatusBar sb) {
		return sb.hpl.CountInv('HDZerk') / 105;
	}

    override string FormatValue(HCStatusBar sb, float counterValue) {
        return String.Format("%i%%", counterValue);
    }
}