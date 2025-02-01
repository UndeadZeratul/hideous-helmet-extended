const HDCONST_MLTOLITRE = 0.001;

class UZHydroCounter : BaseCounterHUDElement {

    private transient Service _service;

    private transient CVar _units;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "hydroCounter";

        counterIcon   = "HYDCNTR0";
        counterIconBG = "HYDCNTR1";
        counterLabel  = Stringtable.Localize("$HHXHydroCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }
    
    override void Tick(HCStatusbar sb) {
        super.Tick(sb);

        if (!_service) _service = ServiceIterator.Find("UaS_HungerStatus").next();

        if (!_units) _units = CVar.GetCVar("uz_hhx_"..Namespace.."_units", sb.CPlayer);
    }

    override float GetCounterValue(HCStatusbar sb) {
        return _service ? _service.GetIntUI("Hydro", objectArg:sb.hpl) : -1;
    }

    override string FormatValue(HCStatusbar sb, float counterValue, float maxValue) {

        float  amt = 0.;
        string units;
        string format;
        switch (_units.GetInt()) {
            case 1:
            amt   = counterValue * HDCONST_MLTOLITRE;
            units = "L";
            format = "%.2f %s";
            break;
            case 2:
            amt   = counterValue * HDCONST_MLTOLITRE * HDCONST_LITRETOFLOZ;
            units = "fl oz";
            format = "%.2f %s";
            break;
            case 3:
            amt   = counterValue * HDCONST_MLTOLITRE * HDCONST_LITRETOGALLON;
            units = "gal";
            format = "%.2f %s";
            break;
            default:
            amt   = counterValue;
            units = "mL";
            format = "%i %s";
            break;
        }

        return String.Format(format, amt, units);
    }
}