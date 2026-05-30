class UZFragCounter : BaseCounterHUDElement {

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "fragCounter";

        counterIcon   = "FRGCNTR0";
        counterIconBG = "FRGCNTR1";
        counterLabel  = Stringtable.Localize("$HHXFragCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override float GetCounterValue(HCStatusbar sb) {
        let value = 0.0;

        // Count all the nearby Frag Shards
        let iter = ThinkerIterator.create("BFGNecroShard");

        Actor mo;
        while(mo = Actor(iter.next())) {
            if (mo.health) {
                value += 100.0 / max(HDCONST_ONEMETRE ** 2, sb.hpl.Distance3DSquared(mo));
            }
        }

        return value * 1000.0;
    }
}