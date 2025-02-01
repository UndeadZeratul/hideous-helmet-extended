class UZMercBucksCounter : BaseCounterHUDElement {

    private transient Class<Inventory> _invClass;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "mercBucksCounter";

        counterIcon   = "BUXCNTR0";
        counterIconBG = "BUXCNTR1";
        counterLabel  = Stringtable.Localize("$HHXMercBucksCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");

        string invClassName = "MercenaryBucks";
        _invClass = invClassName;
    }

    override float GetCounterValue(HCStatusbar sb) {
        return _invClass ? sb.hpl.countInv(_invClass) : 0;
    }

    override string FormatValue(HCStatusbar sb, float counterValue, float maxValue) {
        return String.Format("$%i", counterValue);
    }
}