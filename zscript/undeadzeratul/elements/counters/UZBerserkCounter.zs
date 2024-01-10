class UZBerserkCounter : BaseCounterHUDElement {

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "berserkCounter";

        counterIcon   = "ZRKCNTR0";
        counterIconBG = "ZRKCNTR1";
        counterLabel  = Stringtable.Localize("$HHXBerserkCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override bool ShouldDrawCounter(HCStatusBar sb, float counterValue) {
        return sb.hpl.CountInv("HDZerk") > 10500;
    }

    override float GetCounterValue(HCStatusBar sb) {
        return (sb.hpl.CountInv('HDZerk') - 10500) / 84;
    }

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {
        return String.Format("%i%%", counterValue);
    }
}