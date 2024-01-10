class UZStunnedCounter : BaseCounterHUDElement {

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "stunnedCounter";

        counterIcon   = "STNCNTR0";
        counterIconBG = "STNCNTR1";
        counterLabel  = Stringtable.Localize("$HHXStunnedCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override float GetCounterValue(HCStatusBar sb) {
        return sb.hpl.stunned / 35;
    }

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {
        if (counterValue < 60) return String.Format("%02.1f", counterValue);
        else if (counterValue < 3600) return String.Format("%i:%02.1f", counterValue/60, counterValue%60);
        else if (counterValue < 86400) return String.Format("%i:%02i:%02.1f", counterValue/3600, (counterValue%3600)/60, (counterValue%3600)%60);
        else return String.Format("%i:%02i:%02i:%02.1f", counterValue/86400, (counterValue%86400)/3600, ((counterValue%86400)%3600)/60, ((counterValue%86400)%3600)%60);
    }
}