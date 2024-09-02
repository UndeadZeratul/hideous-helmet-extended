class UZAirToxicityCounter : BaseCounterHUDElement {

    Service service;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "airToxicityCounter";

        counterIcon   = "ATXCNTR0";
        counterIconBG = "ATXCNTR1";
        counterLabel  = Stringtable.Localize("$HHXAirToxicityCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");

        service = ServiceIterator.Find("SpicyAirService").next();
    }

    override float GetCounterValue(HCStatusBar sb) {
        let maxToxicity = GetMaxAirToxicity(sb);
        return maxToxicity > 0 ? GetAirToxicity(sb) / maxToxicity * GetCounterMaxValue(sb) : 0.0;
    }

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {
        return String.Format("%.2f%%", counterValue * 100.0);
    }

    private float GetAirToxicity(HCStatusBar sb) {
        return service
            ? service.GetDoubleUI("GetAirToxicity", objectArg: sb.hpl)
            : 0.0;
    }

    private float GetMaxAirToxicity(HCStatusBar sb) {
        return service
            ? service.GetDoubleUI("GetMaxAirToxicity", objectArg: sb.hpl)
            : -1;
    }
}
