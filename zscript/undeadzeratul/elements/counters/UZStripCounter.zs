class UZStripCounter : BaseCounterHUDElement {

    private transient CVar _units;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "stripCounter";

        counterIcon   = "STPCNTR0";
        counterIconBG = "STPCNTR1";
        counterLabel  = Stringtable.Localize("$HHXStripCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override void Tick(HCStatusbar sb) {
        super.Tick(sb);

        if (!_units) _units = CVar.GetCVar("uz_hhx_"..Namespace.."_units", sb.CPlayer);
    }

    override float GetCounterValue(HCStatusbar sb) {
        return sb.hpl.striptime;
    }

    override string FormatValue(HCStatusbar sb, float counterValue, float maxValue) {
        return _units.GetInt()
            ? String.Format("%.2f %s", counterValue / 35., StringTable.Localize("$HHXSeconds"))
            : String.Format("%i %s",   counterValue,       StringTable.Localize("$HHXTics"));
    }
}