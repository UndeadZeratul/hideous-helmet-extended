class UZLevelSecretsCounter : BaseCounterHUDElement {

    private transient CVar _units;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "levelSecretsCounter";

        counterIcon   = "LVSCNTR0";
        counterIconBG = "LVSCNTR1";
        counterLabel  = Stringtable.Localize("$HHXLevelSecretsCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override void Tick(HCStatusbar sb) {
        super.Tick(sb);

        if (!_units) _units = CVar.GetCVar("uz_hhx_"..Namespace.."_units", sb.CPlayer);
    }

    override bool ShouldDrawCounter(HCStatusbar sb, float counterValue) {
        let maxValue = GetCounterMaxValue(sb);
        return maxValue > 0 && maxValue - counterValue;
    }

    override float GetCounterValue(HCStatusbar sb) {
        return Level.found_secrets;
    }

    override float GetCounterMaxValue(HCStatusbar sb) {
        return Level.total_secrets;
    }

    override string FormatValue(HCStatusbar sb, float counterValue, float maxValue) {


        switch (_units.GetInt()) {
            case 0:
                return sb.FormatNumber(counterValue);
            case 1:
                return String.Format("%i / %i", counterValue, maxValue);
            case 2:
                return String.Format("%i%%", maxValue > 0 ? counterValue / maxValue * 100.0 : 100.0);
            case 3:
                return sb.FormatNumber(maxValue - counterValue);
            case 4:
                return String.Format("%i / %i", maxValue - counterValue, maxValue);
            case 5:
                return String.Format("%i%%", maxValue > 0 ? (maxValue - counterValue) / maxValue * 100.0 : 0);
            default:
                return sb.FormatNumber(counterValue);
        }
    }
}