class HHOverlay : HUDElement {

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
		ZLayer = -1;
		Namespace = "helmet";
	}

	override void Tick(HCStatusbar sb) {
		if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

		if (!_ref) _ref                   = CVar.GetCVar("uz_hhx_overlay_ref", sb.CPlayer);
		if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_overlay_enabled", sb.CPlayer);
		if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_overlay_hlm_required", sb.CPlayer);
		if (!_hlm_hudLevel) _hlm_hudLevel = CVar.GetCVar("uz_hhx_overlay_hlm_hudLevel", sb.CPlayer);
		if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_overlay_hlm_posX", sb.CPlayer);
		if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_overlay_hlm_posY", sb.CPlayer);
		if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_overlay_hlm_scale", sb.CPlayer);
		if (!_nhm_hudLevel) _nhm_hudLevel = CVar.GetCVar("uz_hhx_overlay_nhm_hudLevel", sb.CPlayer);
		if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_overlay_nhm_posX", sb.CPlayer);
		if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_overlay_nhm_posY", sb.CPlayer);
		if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_overlay_nhm_scale", sb.CPlayer);
	}

	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
		bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);
		int  hudLevel  = hasHelmet ? _hlm_hudLevel.GetInt() : _nhm_hudLevel.GetInt();
		
		if (
			!_enabled.GetBool()
			|| (!hasHelmet && _hlm_required.GetBool())
			|| sb.HUDLevel < hudLevel
		) return;

		if(CheckCommonStuff(sb, state, ticFrac)) {
			int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
			int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
			float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();

			sb.DrawImage(
				_ref.GetString(),
				(posX,posY),
				sb.DI_SCREEN_CENTER_BOTTOM,
				scale: (scale, scale)
			);
		}
	}
}
