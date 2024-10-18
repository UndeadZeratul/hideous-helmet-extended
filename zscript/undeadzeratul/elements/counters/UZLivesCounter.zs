class UZLivesCounter : BaseCounterHUDElement {

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "frags"; // in order to override the HUDCore Element

        counterIcon   = "LIVCNTR0";
        counterIconBG = "LIVCNTR1";
        counterLabel  = Stringtable.Localize("$HHXLivesCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override void Tick(HCStatusbar sb) {
        Namespace = "livesCounter"; // in order to keep up with the CVAR naming convention

        super.Tick(sb);

        Namespace = "frags";
    }

    override bool ShouldDrawCounter(HCStatusBar sb, float counterValue) {
        return deathmatch || fraglimit > 0;
    }

    override float GetCounterValue(HCStatusBar sb) {
        return sb.cplayer.fragcount;
    }

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {
        return String.Format("%.0f", counterValue);
    }
}
