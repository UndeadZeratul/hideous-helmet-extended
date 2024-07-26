class UZSpicyAirCounter : BaseCounterHUDElement {

    Class<Inventory> invClass;

    Service service;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "spicyAirCounter";

        counterIcon   = "TOXCNTR0";
        counterIconBG = "TOXCNTR1";
        counterLabel  = Stringtable.Localize("$HHXSpicyAirCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");

        string invClassName = "Despicyto";
        invClass = invClassName;

        service = ServiceIterator.Find("SpicyAirService").next();
    }

    override bool ShouldDrawCounter(HCStatusBar sb, float counterValue) {
        return !IsGasMaskWorn(sb);
    }

    override float GetCounterValue(HCStatusBar sb) {
        return GetCounterMaxValue(sb) - GetBreathHoldTimer(sb);
    }

    override float GetCounterMaxValue(HCStatusBar sb) {
        return Level.airSupply * sb.hpl.airCapacity;
    }

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {
        return (Level.airSupply <= 0 && sb.hpl.airCapacity <= 0) || IsGasMaskWorn(sb)
                ? "0.00%"
                : String.Format("%.2f%%", clamp(counterValue / maxValue * 100.0, 0.0, 100.0));
    }

    private bool IsGasMaskWorn(HCStatusBar sb) {
        return service && int(service.GetIntUI("IsGasMaskWorn", objectArg: sb.hpl.FindInventory(invClass)));
    }

    private float GetBreathHoldTimer(HCStatusBar sb) {
        return service
            ? service.GetIntUI("GetBreathHoldTimer", objectArg: sb.hpl)
            : GetCounterMaxValue(sb);
    }
}
