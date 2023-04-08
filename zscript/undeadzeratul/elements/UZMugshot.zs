class UZMugshot : HUDMugshot {

	private Service _HHFunc;

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

	private transient CVar _nhm_bgRef;
	private transient CVar _nhm_bgPosX;
	private transient CVar _nhm_bgPosY;
	private transient CVar _nhm_bgScale;
	private transient CVar _hlm_bgRef;
	private transient CVar _hlm_bgPosX;
	private transient CVar _hlm_bgPosY;
	private transient CVar _hlm_bgScale;

	override void Tick(HCStatusbar sb) {
		if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();
		
		if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_mugshot_enabled", sb.CPlayer);
		if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_mugshot_hlm_required", sb.CPlayer);
		if (!_hlm_hudLevel) _hlm_hudLevel = CVar.GetCVar("uz_hhx_mugshot_hlm_hudLevel", sb.CPlayer);
		if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_mugshot_hlm_posX", sb.CPlayer);
		if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_mugshot_hlm_posY", sb.CPlayer);
		if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_mugshot_hlm_scale", sb.CPlayer);
		if (!_nhm_hudLevel) _nhm_hudLevel = CVar.GetCVar("uz_hhx_mugshot_nhm_hudLevel", sb.CPlayer);
		if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_mugshot_nhm_posX", sb.CPlayer);
		if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_mugshot_nhm_posY", sb.CPlayer);
		if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_mugshot_nhm_scale", sb.CPlayer);

		if (!_nhm_bgRef) _nhm_bgRef       = CVar.GetCVar("uz_hhx_mugshot_bg_nhm_ref", sb.CPlayer);
		if (!_nhm_bgPosX) _nhm_bgPosX     = CVar.GetCVar("uz_hhx_mugshot_bg_nhm_posX", sb.CPlayer);
		if (!_nhm_bgPosY) _nhm_bgPosY     = CVar.GetCVar("uz_hhx_mugshot_bg_nhm_posY", sb.CPlayer);
		if (!_nhm_bgScale) _nhm_bgScale   = CVar.GetCVar("uz_hhx_mugshot_bg_nhm_scale", sb.CPlayer);
		if (!_hlm_bgRef) _hlm_bgRef       = CVar.GetCVar("uz_hhx_mugshot_bg_hlm_ref", sb.CPlayer);
		if (!_hlm_bgPosX) _hlm_bgPosX     = CVar.GetCVar("uz_hhx_mugshot_bg_hlm_posX", sb.CPlayer);
		if (!_hlm_bgPosY) _hlm_bgPosY     = CVar.GetCVar("uz_hhx_mugshot_bg_hlm_posY", sb.CPlayer);
		if (!_hlm_bgScale) _hlm_bgScale   = CVar.GetCVar("uz_hhx_mugshot_bg_hlm_scale", sb.CPlayer);
	}

	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
		bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);
		int  hudLevel  = hasHelmet ? _hlm_hudLevel.GetInt() : _nhm_hudLevel.GetInt();
		
		if (
			!_enabled.GetBool()
			|| (!hasHelmet && _hlm_required.GetBool())
			|| HDSpectator(sb.hpl)
			|| sb.HUDLevel < hudLevel
		) return;

		TextureID ms = sb.GetMugShot(5,Mugshot.CUSTOM,sb.GetMug(sb.hpl.mugshot));
		double alpha = sb.blurred?0.2:1.;

		if (AutomapActive){
			sb.drawTexture(ms, (6,-14), sb.DI_BOTTOMLEFT, alpha);
		} else if (CheckCommonStuff(sb, state, ticFrac) && sb.usemughud) {

			int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
			int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
			float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();

			string bgRef   = hasHelmet ? _hlm_bgRef.GetString()  : _nhm_bgRef.GetString();
			int    bgPosX  = hasHelmet ? _hlm_bgPosX.GetInt()    : _nhm_bgPosX.GetInt();
			int    bgPosY  = hasHelmet ? _hlm_bgPosY.GetInt()    : _nhm_bgPosY.GetInt();
			float  bgScale = hasHelmet ? _hlm_bgScale.GetFloat() : _nhm_bgScale.GetFloat();

			// Draw HUD Element Background Image if it's defined
			sb.DrawImage(
				bgRef,
				(posX + bgPosX, posY + bgPosY),
				sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_CENTER_BOTTOM,
				scale: (scale * bgScale, scale * bgScale)
			);

			sb.drawTexture(
				ms,
				(posX,posY), 
				sb.DI_ITEM_CENTER_BOTTOM|sb.DI_SCREEN_CENTER_BOTTOM,
				alpha,
				scale: (scale, scale)
			);
		}
	}
}
