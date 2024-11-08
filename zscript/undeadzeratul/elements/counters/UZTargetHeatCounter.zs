class UZTargetHeatCounter : BaseCounterHUDElement {

    private HHXHandler _handler;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "TargetHeatCounter";

        counterIcon   = "THTCNTR0";
        counterIconBG = "THTCNTR1";
        counterLabel  = Stringtable.Localize("$HHXTargetHeatCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override void Tick(HCStatusBar sb) {
        super.Tick(sb);

        if (!_handler) _handler = HHXHandler(EventHandler.Find('HHXHandler'));
    }

    override float GetCounterValue(HCStatusBar sb) {
        if (_handler) {
            let data = _handler.data[sb.hpl.PlayerNumber()];

            if (data && data.hitActor && HDMobBase(data.hitActor)) {
                let heat = Heat(data.hitActor.findinventory('Heat'));

                if (heat && heat.realAmount > 0) {
                    return heat.realAmount;
                }
            }
        }

        return 0;
    }
}