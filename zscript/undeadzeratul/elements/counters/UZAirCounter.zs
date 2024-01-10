class UZAirCounter : BaseCounterHUDElement {

    Class<Inventory> invClass;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "airCounter";

        counterIcon   = "AIRCNTR0";
        counterIconBG = "AIRCNTR1";
        counterLabel  = Stringtable.Localize("$HHXAirCounterLabel")..Stringtable.Localize("$HHXCounterSeparator");

        string invClassName = "UaS_Respirator";
        invClass = invClassName;
    }

    override bool ShouldDrawCounter(HCStatusBar sb, float counterValue) {
        return sb.hpl.waterLevel >= 3;
    }

    override float GetCounterValue(HCStatusBar sb) {
        return (sb.hpl.waterLevel < 3 || (sb.hpl.CountInv(invClass) && IsUsingRespirator(sb.hpl)))
            ? GetCounterMaxValue(sb)
            : max(0.0, (sb.hpl.player.air_finished - Level.mapTime));
    }

    override float GetCounterMaxValue(HCStatusBar sb) {
        return Level.airSupply * sb.hpl.airCapacity;
    }

    override string FormatValue(HCStatusBar sb, float counterValue, float maxValue) {
        return (Level.airSupply > 0 && sb.hpl.airCapacity > 0)
            ? (sb.hpl.waterLevel < 3 || (sb.hpl.CountInv(invClass) && IsUsingRespirator(sb.hpl)))
                ? "100.00%"
                : String.Format("%.2f%%", counterValue / maxValue * 100.0)
            : "Infinite";
    }
    
    private bool IsUsingRespirator(PlayerPawn p) {
        service RespStatus = ServiceIterator.Find("UaS_RespiratorStatus").next();
        return RespStatus && int(RespStatus.GetIntUI("IsWorn", objectArg:p));
    }
}