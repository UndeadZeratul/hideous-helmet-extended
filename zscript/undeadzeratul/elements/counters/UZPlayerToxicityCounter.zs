class UZPlayerToxicityCounter : BaseCounterHUDElement {

    Class<Inventory> invClass;

    Service service;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "playerToxicityCounter";

        counterIcon   = "PTXCNTR0";
        counterIconBG = "PTXCNTR1";
        counterLabel  = Stringtable.Localize("$HHXPlayerToxicityCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");

        string invClassName = "Despicyto";
        invClass = invClassName;

        service = ServiceIterator.Find("SpicyAirService").next();
    }

    override bool ShouldDrawCounter(HCStatusBar sb, float counterValue) {
        return !IsGasMaskWorn(sb);
    }

    override float GetCounterValue(HCStatusBar sb) {
        return clamp(GetPlayerToxicity(sb), 0, GetCounterMaxValue(sb));
    }

    override float GetCounterMaxValue(HCStatusBar sb) {
        let maxToxicity = GetMaxPlayerToxicity(sb);
        return maxToxicity > -1 ? maxToxicity : super.GetCounterMaxValue(sb);
    }

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {
        return (Level.airSupply <= 0 && sb.hpl.airCapacity <= 0) || IsGasMaskWorn(sb)
                ? "0.00%"
                : String.Format("%.2f%%", clamp(counterValue / maxValue * 100.0, 0.0, 100.0));
    }

    private bool IsGasMaskWorn(HCStatusBar sb) {
        return service && int(service.GetIntUI("IsGasMaskWorn", objectArg: sb.hpl.FindInventory(invClass)));
    }

    private float GetPlayerToxicity(HCStatusBar sb) {
        return service
            ? service.GetIntUI("GetPlayerToxicity", objectArg: sb.hpl)
            : GetCounterMaxValue(sb);
    }

    private float GetMaxPlayerToxicity(HCStatusBar sb) {
        return service
            ? service.GetIntUI("GetMaxPlayerToxicity", objectArg: sb.hpl)
            : -1;
    }
}
