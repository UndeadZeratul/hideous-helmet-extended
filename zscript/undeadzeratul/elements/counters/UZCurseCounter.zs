class UZCurseCounter : BaseCounterHUDElement {

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "curseCounter";

        counterIcon   = "CRSCNTR0";
        counterIconBG = "CRSCNTR1";
        counterLabel  = Stringtable.Localize("$HHXCurseCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override float GetCounterValue(HCStatusbar sb) {
        let value = 0;

        // Count all the active curses
        let iter = ThinkerIterator.create("NecromancerGhost");
        while(iter.next()) value++;

        return value;
    }
}