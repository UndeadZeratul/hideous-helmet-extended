class UZHeatCounter : BaseCounterHUDElement {

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "heatCounter";

        counterIcon   = "HETCNTR0";
        counterIconBG = "HETCNTR1";
        counterLabel  = Stringtable.Localize("$HHXHeatCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override float GetCounterValue(HCStatusbar sb) {
        let heat = Heat(sb.hpl.FindInventory("Heat"));

        return heat ? heat.realAmount : 0;
    }
}