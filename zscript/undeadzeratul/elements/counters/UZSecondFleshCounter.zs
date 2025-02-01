class UZSecondFleshCounter : BaseCounterHUDElement {

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "secondFleshCounter";

        counterIcon   = "2FCNTR0";
        counterIconBG = "2FCNTR1";
        counterLabel  = Stringtable.Localize("$HHXSecondFleshCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override float GetCounterValue(HCStatusbar sb) {
        return sb.hpl.CountInv('SecondFlesh');
    }
}