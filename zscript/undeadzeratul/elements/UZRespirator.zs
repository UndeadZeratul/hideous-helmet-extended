class UZRespirator : HUDElement {

	Class<Inventory> invClass;

	private transient CVar _ref;
	private transient CVar _enabled;

	override void Init(HCStatusbar sb) {
		ZLayer = -1;
		Namespace = "respirator";

		string invClassName = "UaS_Respirator";
		invClass = invClassName;
	}

	override void Tick(HCStatusbar sb) {
		if (!_ref) _ref         = CVar.GetCVar("uz_hhx_respirator_ref", sb.CPlayer);
		if (!_enabled) _enabled = CVar.GetCVar("uz_hhx_respirator_enabled", sb.CPlayer);
	}

	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {

        // Only render if we're wearing a Respirator
        if (
			!_enabled.GetBool()
            || !sb.hpl.CountInv(invClass)
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
		service RespStatus = ServiceIterator.Find("UaS_RespiratorStatus").next();
		return RespStatus && int(RespStatus.GetIntUI("IsWorn", objectArg:p));
	}
}