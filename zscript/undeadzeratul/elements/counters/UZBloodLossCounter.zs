const HDCONST_TUTOMILLILITRE = 1000.;
const HDCONST_TUTOLITRE = 1.;
const HDCONST_LITRETOFLOZ = 33.81413;
const HDCONST_LITRETOGALLON = 0.2641729;

class UZBloodLossCounter : BaseCounterHUDElement {

    private transient CVar _units;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "bloodlossCounter";

        counterIcon   = "BLSCNTR0";
        counterIconBG = "BLSCNTR1";
        counterLabel  = Stringtable.Localize("$HHXBloodLossCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override void Tick(HCStatusbar sb) {
        super.Tick(sb);

        if (!_units) _units = CVar.GetCVar("uz_hhx_"..Namespace.."_units", sb.CPlayer);
    }

    override float GetCounterValue(HCStatusBar sb) {
        return sb.hpl.bloodLoss / 1024.;
    }

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {

        float  amt = 0.;
        string units;
        string format;
        switch (_units.GetInt()) {
            case 0:
            amt   = counterValue * HDCONST_TUTOMILLILITRE;
            units = "mL";
            format = "%.2f %s";
            break;
            case 1:
            amt   = counterValue * HDCONST_TUTOLITRE;
            units = "L";
            format = "%.2f %s";
            break;
            case 2:
            amt   = counterValue * HDCONST_TUTOLITRE * HDCONST_LITRETOFLOZ;
            units = "fl oz";
            format = "%.2f %s";
            break;
            case 3:
            amt   = counterValue * HDCONST_TUTOLITRE * HDCONST_LITRETOGALLON;
            units = "gal";
            format = "%.2f %s";
            break;
            default:
            amt   = counterValue;
            units = StringTable.Localize("$MEDIKIT_TRANSFUSIONUNITS");
            format = "%.2f %s";
            break;
        }

        return String.Format(format, amt, units);
    }
}