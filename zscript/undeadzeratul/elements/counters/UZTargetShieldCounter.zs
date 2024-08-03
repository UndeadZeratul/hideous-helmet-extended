class UZTargetShieldCounter : BaseCounterHUDElement {

    private HHXHandler _handler;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "TargetShieldCounter";

        counterIcon   = "TSHCNTR0";
        counterIconBG = "TSHCNTR1";
        counterLabel  = Stringtable.Localize("$HHXTargetShieldCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");
    }

    override void Tick(HCStatusBar sb) {
        super.Tick(sb);

        if (!_handler) _handler = HHXHandler(EventHandler.Find('HHXHandler'));
    }

    override float GetCounterValue(HCStatusBar sb) {
        if (_handler) {
            let data = _handler.data[sb.hpl.PlayerNumber()];

            if (data && data.hitActor && HDMobBase(data.hitActor)) {
                let shields = data.hitActor.findinventory('HDMagicShield');

                if (shields && shields.amount > 0) {
                    return shields.amount;
                }
            }
        }

        return 0;
    }
}