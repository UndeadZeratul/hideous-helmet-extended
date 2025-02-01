class UZSickCounter : BaseCounterHUDElement {

    private transient Service _service;

    private transient CVar _units;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "sickCounter";

        counterIcon   = "SCKCNTR0";
        counterIconBG = "SCKCNTR1";
        counterLabel  = Stringtable.Localize("$HHXSickCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }
    
    override void Tick(HCStatusbar sb) {
        super.Tick(sb);

        if (!_service) _service = ServiceIterator.Find("UaS_HungerStatus").next();

        if (!_units) _units = CVar.GetCVar("uz_hhx_"..Namespace.."_units", sb.CPlayer);
    }

    override float GetCounterValue(HCStatusbar sb) {
        return _service ? _service.GetIntUI("Sick", objectArg:sb.hpl) : -1;
    }

    override string FormatValue(HCStatusbar sb, float counterValue, float maxValue) {

        float  vel = 0.;
        string units;
        switch (_units.GetInt()) {
            default:
            vel   = counterValue;
            units = "units";
            break;
        }

        return String.Format("%i %s", vel, units);
    }
}