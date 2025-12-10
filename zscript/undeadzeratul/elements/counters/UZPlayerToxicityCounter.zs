class UZPlayerToxicityCounter : BaseCounterHUDElement {

    private transient Class<Inventory> _invClass;

    private transient Service _service;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "playerToxicityCounter";

        counterIcon   = "PTXCNTR0";
        counterIconBG = "PTXCNTR1";
        counterLabel  = Stringtable.Localize("$HHXPlayerToxicityCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");

        string invClassName = "Despicyto";
        _invClass = invClassName;
    }
    
    override void Tick(HCStatusbar sb) {
        super.Tick(sb);

        if (!_service) _service = ServiceIterator.Find("SpicyAirService").next();
    }

    override bool ShouldDrawCounter(HCStatusbar sb, float counterValue) {
        return counterValue > 0;
    }

    override float GetCounterValue(HCStatusbar sb) {
        return clamp(GetPlayerToxicity(sb), 0, GetCounterMaxValue(sb));
    }

    override float GetCounterMaxValue(HCStatusbar sb) {
        let maxToxicity = GetMaxPlayerToxicity(sb);
        return maxToxicity > -1 ? maxToxicity : super.GetCounterMaxValue(sb);
    }

    override string FormatValue(HCStatusbar sb, float counterValue, float maxValue) {
        return (Level.airSupply <= 0 && sb.hpl.airCapacity <= 0)
                ? "0.00%"
                : String.Format("%.2f%%", clamp(counterValue / maxValue * 100.0, 0.0, 100.0));
    }

    private float GetPlayerToxicity(HCStatusbar sb) {
        return _service
            ? _service.GetIntUI("GetPlayerToxicity", objectArg: sb.hpl)
            : GetCounterMaxValue(sb);
    }

    private float GetMaxPlayerToxicity(HCStatusbar sb) {
        return _service
            ? _service.GetIntUI("GetMaxPlayerToxicity", objectArg: sb.hpl)
            : -1;
    }
}
