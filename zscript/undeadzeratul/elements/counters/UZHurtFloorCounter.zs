class UZHurtFloorCounter : BaseCounterHUDElement {

    private HHXHandler _handler;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "HurtFloorCounter";

        counterIcon   = "FLRCNTR0";
        counterIconBG = "FLRCNTR1";
        counterLabel  = Stringtable.Localize("$HHXHurtFloorCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override void Tick(HCStatusBar sb) {
        super.Tick(sb);

        if (!_handler) _handler = HHXHandler(EventHandler.Find('HHXHandler'));
    }

    override float GetCounterValue(HCStatusBar sb) {
        if (_handler) {
            let data = _handler.data[sb.hpl.PlayerNumber()];

            if (data && data.hitType == TRACE_HitFloor && data.hitSector.damageamount > 0) {
                return data.hitSector.damageamount;
            }
        }

        return 0;
    }
}