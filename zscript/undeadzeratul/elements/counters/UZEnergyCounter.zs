const HDCONST_CALTOJOULES = 4.18;
CONST HDCONST_KCALTOCAL = 1000;

class UZEnergyCounter : BaseCounterHUDElement {

    private transient Service _service;

    private transient CVar _units;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "energyCounter";

        counterIcon   = "HNGCNTR0";
        counterIconBG = "HNGCNTR1";
        counterLabel  = Stringtable.Localize("$HHXEnergyCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }
    
    override void Tick(HCStatusbar sb) {
        super.Tick(sb);

        if (!_service) _service = ServiceIterator.Find("UaS_HungerStatus").next();

        if (!_units) _units = CVar.GetCVar("uz_hhx_"..Namespace.."_units", sb.CPlayer);
    }

    override float GetCounterValue(HCStatusbar sb) {
        return _service ? _service.GetIntUI("Energy", objectArg:sb.hpl) : -1;
    }

    override string FormatValue(HCStatusbar sb, float counterValue, float maxValue) {
        float  amt = 0.;
        string units;
        string format;

        switch (_units.GetInt()) {
            case 1:
            amt   = counterValue;
            units = "kcal";
            format = "%i %s";
            break;
            case 2:
            amt   = counterValue * HDCONST_KCALTOCAL;
            units = "Calories";
            format = "%i %s";
            break;
            case 3:
            amt   = counterValue * HDCONST_CALTOJOULES;
            units = "joules";
            format = "%.2f %s";
            break;
            default:
            amt   = counterValue;
            units = "Calories";
            format = "%i %s";
            break;
        }

        return String.Format("%i %s", amt, units);
    }
}