const HDCONST_METRETOFEET=3.28084;
const HDCONST_FEETTOMILE=0.0001893939;

class UZTargetDistanceCounter : BaseCounterHUDElement {

    private HHXHandler _handler;

    private transient CVar _units;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "TargetDistanceCounter";

        counterIcon   = "TDTCNTR0";
        counterIconBG = "TDTCNTR1";
        counterLabel  = Stringtable.Localize("$HHXTargetDistanceCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override void Tick(HCStatusbar sb) {
        super.Tick(sb);

        if (!_handler) _handler = HHXHandler(EventHandler.Find('HHXHandler'));

        if (!_units) _units = CVar.GetCVar("uz_hhx_"..Namespace.."_units", sb.CPlayer);
    }

    override float GetCounterValue(HCStatusbar sb) {
        if (_handler) {
            let data = _handler.lineTraceData[sb.hpl.PlayerNumber()];

            if (data) return data.distance;
        }

        return 0;
    }

    override string FormatValue(HCStatusbar sb, float counterValue, float maxValue) {

        float  dist = 0.;
        string units;
        switch (_units.GetInt()) {
            case 0:
            dist  = counterValue / HDCONST_ONEMETRE * 1.0;
            units = "m";
            break;
            case 1:
            dist  = counterValue / HDCONST_ONEMETRE / 1000.;
            units = "km";
            break;
            case 2:
            dist  = counterValue / HDCONST_ONEMETRE * HDCONST_METRETOFEET;
            units = "ft";
            break;
            case 3:
            dist  = counterValue / HDCONST_ONEMETRE * HDCONST_METRETOFEET * HDCONST_FEETTOMILE;
            units = "mi";
            break;
            default:
            dist  = counterValue;
            units = "mu";
            break;
        }

        return String.Format("%.2f%s", dist, units);
    }
}