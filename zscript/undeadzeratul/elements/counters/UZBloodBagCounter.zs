class UZBloodBagCounter : BaseCounterHUDElement {

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "bloodBagCounter";

        counterIcon   = "BBGCNTR0";
        counterIconBG = "BBGCNTR1";
        counterLabel  = Stringtable.Localize("$HHXBloodBagCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override bool ShouldDrawCounter(HCStatusbar sb, float counterValue) {
        return sb.hpl.FindInventory("BloodBagWorn");
    }

    override float GetCounterValue(HCStatusbar sb) {
        let bloodBag = BloodBagWorn(sb.hpl.FindInventory("BloodBagWorn"));

        return bloodBag ? (bloodBag.bloodLeft * 100 / 256) : 0;
    }

    override string FormatValue(HCStatusbar sb, float counterValue, float maxValue) {
        return String.Format("%i%%", counterValue);
    }
}