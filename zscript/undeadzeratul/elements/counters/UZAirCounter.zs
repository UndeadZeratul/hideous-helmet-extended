class UZAirCounter : BaseCounterHUDElement {

    private transient Class<Inventory> _invClass;

    private transient Service _service;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "airCounter";

        counterIcon   = "AIRCNTR0";
        counterIconBG = "AIRCNTR1";
        counterLabel  = Stringtable.Localize("$HHXAirCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");

        string invClassName = "UaS_Respirator";
        _invClass = invClassName;
    }

    override void Tick(HCStatusbar sb) {
        super.Tick(sb);

        if (!_service) _service = ServiceIterator.Find("UaS_RespiratorStatus").next();
    }

    override bool ShouldDrawCounter(HCStatusbar sb, float counterValue) {
        return sb.hpl.waterLevel >= 3;
    }

    override float GetCounterValue(HCStatusbar sb) {
        return (sb.hpl.waterLevel < 3 || (sb.hpl.CountInv(_invClass) && IsUsingRespirator(sb.hpl)))
            ? GetCounterMaxValue(sb)
            : max(0.0, (sb.hpl.player.air_finished - Level.mapTime));
    }

    override float GetCounterMaxValue(HCStatusbar sb) {
        return Level.airSupply * sb.hpl.airCapacity;
    }

    override string FormatValue(HCStatusbar sb, float counterValue, float maxValue) {
        return (Level.airSupply > 0 && sb.hpl.airCapacity > 0)
            ? (sb.hpl.waterLevel < 3 || (sb.hpl.CountInv(_invClass) && IsUsingRespirator(sb.hpl)))
                ? "100.00%"
                : String.Format("%.2f%%", counterValue / maxValue * 100.0)
            : "Infinite";
    }

    private bool IsUsingRespirator(PlayerPawn p) {
        return _service && int(_service.GetIntUI("IsWorn", objectArg: p));
    }
}
