class UZRespirator : HUDElement {

    private transient Class<Inventory> _invClass;

    private transient Service _service;

    private transient CVar _enabled;

    private transient CVar _ref;

    override void Init(HCStatusbar sb) {
        ZLayer = -1;
        Namespace = "respirator";

        string invClassName = "UaS_Respirator";
        _invClass = invClassName;
    }

    override void Tick(HCStatusbar sb) {
        if (!_service) _service = ServiceIterator.Find("UaS_RespiratorStatus").next();

        if (!_enabled) _enabled = CVar.GetCVar("uz_hhx_respirator_enabled", sb.CPlayer);

        if (!_ref) _ref         = CVar.GetCVar("uz_hhx_respirator_ref", sb.CPlayer);
    }

    override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {

        // Only render if we're wearing a Respirator
        // TODO: Add check against Automap
        if (
            !_enabled.GetBool()
            || !sb.hpl.CountInv(_invClass)
            || !IsUsingRespirator(sb.hpl)
        ) return;

        // Get the Respirator Overlay Graphic
        string ref = _ref.GetString();

        sb.DrawImage(
            ref,
            (0, 0),
            sb.DI_SCREEN_CENTER_BOTTOM
        );
    }
    
    private bool IsUsingRespirator(PlayerPawn p) {
        return _service && int(_service.GetIntUI("IsWorn", objectArg:p));
    }
}