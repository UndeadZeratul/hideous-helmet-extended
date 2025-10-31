class UZAirToxicityCounter : BaseCounterHUDElement {

    private transient Service _service;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "airToxicityCounter";

        counterIcon   = "ATXCNTR0";
        counterIconBG = "ATXCNTR1";
        counterLabel  = Stringtable.Localize("$HHXAirToxicityCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }
    
    override void Tick(HCStatusbar sb) {
        super.Tick(sb);

        if (!_service) _service = ServiceIterator.Find("SpicyAirService").next();
    }

    override float GetCounterValue(HCStatusbar sb) {
        return GetAirToxicity(sb);
    }

    override float GetCounterMaxValue(HCStatusbar sb) {
        return GetMaxAirToxicity(sb);
    }

    override string FormatValue(HCStatusbar sb, float counterValue, float maxValue) {
        return String.Format("%.2f%%", clamp(counterValue, 0.0, maxValue) / maxValue * 100.0);
    }

    private float GetAirToxicity(HCStatusbar sb) {
        return _service ? _service.GetDoubleUI("GetAirToxicity", objectArg: sb.hpl) : 0.0;
    }

    private float GetMaxAirToxicity(HCStatusbar sb) {
        return _service ? _service.GetDoubleUI("GetMaxAirToxicity", objectArg: sb.hpl) : 0.0;
    }
}
