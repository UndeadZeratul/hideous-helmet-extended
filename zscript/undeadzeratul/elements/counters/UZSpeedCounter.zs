const HDCONST_KPHTOMPH = 0.6213712;

class UZSpeedCounter : BaseCounterHUDElement {

    private transient CVar _units;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "speedCounter";

        counterIcon   = "SPDCNTR0";
        counterIconBG = "SPDCNTR1";
        counterLabel  = Stringtable.Localize("$HHXSpeedCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override void Tick(HCStatusbar sb) {
        super.Tick(sb);

        if (!_units) _units = CVar.GetCVar("uz_hhx_"..Namespace.."_units", sb.CPlayer);
    }

    override float GetCounterValue(HCStatusBar sb) {
        return sb.hpl.vel.length();
    }

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {

        float  vel = 0.;
        string units;
        switch (_units.GetInt()) {
            case 0:
            vel   = counterValue * HDCONST_MPSTODUPT;
            units = "m/s";
            break;
            case 1:
            vel   = counterValue * HDCONST_MPSTODUPT * HDCONST_MPSTOKPH;
            units = "km/h";
            break;
            case 2:
            vel   = counterValue * HDCONST_MPSTODUPT * HDCONST_MPSTOKPH * HDCONST_KPHTOMPH;
            units = "mph";
            break;
            default:
            vel   = counterValue;
            units = "mu/s";
            break;
        }

        return String.Format("%s %s", sb.FormatNumber(vel, 2, format: sb.FNF_FILLZEROS), units);
    }
}