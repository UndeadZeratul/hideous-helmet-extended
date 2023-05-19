class UZRadsuit : HUDElement {

	private Service _HHFunc;
	
	private transient CVar _ref;

	private transient CVar _enabled;
	private transient CVar _hlm_required;

	private transient CVar _hlm_hudLevel;
	private transient CVar _hlm_posX;
	private transient CVar _hlm_posY;
	private transient CVar _hlm_scale;
	private transient CVar _nhm_hudLevel;
	private transient CVar _nhm_posX;
	private transient CVar _nhm_posY;
	private transient CVar _nhm_scale;
	
	override void Init(HCStatusbar sb) {
		ZLayer = -2;
		Namespace = "radsuit";
	}

	override void Tick(HCStatusbar sb) {
		if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

		if (!_ref) _ref                   = CVar.GetCVar("uz_hhx_radsuit_ref", sb.CPlayer);
		if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_radsuit_enabled", sb.CPlayer);
		if (!_nhm_hudLevel) _nhm_hudLevel = CVar.GetCVar("uz_hhx_radsuit_nhm_hudLevel", sb.CPlayer);
		if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_radsuit_nhm_posX", sb.CPlayer);
		if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_radsuit_nhm_posY", sb.CPlayer);
		if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_radsuit_nhm_scale", sb.CPlayer);
		if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_radsuit_hlm_required", sb.CPlayer);
		if (!_hlm_hudLevel) _hlm_hudLevel = CVar.GetCVar("uz_hhx_radsuit_hlm_hudLevel", sb.CPlayer);
		if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_radsuit_hlm_posX", sb.CPlayer);
		if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_radsuit_hlm_posY", sb.CPlayer);
		if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_radsuit_hlm_scale", sb.CPlayer);
	}

	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {

        // Only render if we're wearing a Radsuit
        if (!sb.hpl.CountInv('WornRadsuit')) return;

		// Get the current HUD Scaling value
		Vector2 hudScale = sb.GetHUDScale();

		// Store the raw dimensions of the Background Image
		int bgWidth;
		int bgHeight;
		[bgWidth, bgHeight] = TexMan.GetSize(TexMan.CheckForTexture("DESPMASK"));

		// Calculate the proper scaling value based on the raw dimensions between the Background Image and the screen
		Double scaleX = 1. / bgWidth / hudScale.x * Screen.GetWidth();
		Double scaleY = 1. / bgHeight / hudScale.y * Screen.GetHeight();

		Vector2 bgScale = ((Double(bgWidth) / Double(bgHeight)) - Screen.GetAspectRatio()) < 0 ? (scaleX, scaleX) : (scaleY, scaleY);

		sb.DrawImage(
			"DESPMASK",
			(0, 0),
			sb.DI_SCREEN_CENTER_BOTTOM,
			scale: bgScale
		);
	}
}
