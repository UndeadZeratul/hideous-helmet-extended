class UZHurtFloorCounter : BaseCounterHUDElement {

    private HHXHandler _handler;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "HurtFloorCounter";

        counterIcon   = "FLRCNTR0";
        counterIconBG = "FLRCNTR1";
        counterLabel  = Stringtable.Localize("$HHXHurtFloorCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override void Tick(HCStatusbar sb) {
        super.Tick(sb);

        if (!_handler) _handler = HHXHandler(EventHandler.Find('HHXHandler'));
    }

    override float GetCounterValue(HCStatusbar sb) {
        if (_handler) {
            let data = _handler.lineTraceData[sb.hpl.PlayerNumber()];

            if (data && data.hitType == TRACE_HitFloor && data.hitSector.damageamount > 0) {
                return data.hitSector.damageamount;
            }
        }

        return 0;
    }
}