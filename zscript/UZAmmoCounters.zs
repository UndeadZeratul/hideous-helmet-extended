class UZAmmoCounters : HUDAmmoCounters {

	private Service _HHFunc;

	private transient CVar _enabled;

	private transient CVar _nhm_hudLevel;
	private transient CVar _nhm_posX;
	private transient CVar _nhm_posY;
	private transient CVar _nhm_scale;
	private transient CVar _nhm_xScale;
	private transient CVar _nhm_yScale;
	private transient CVar _nhm_wrapLength;

	private transient CVar _hlm_required;
	private transient CVar _hlm_hudLevel;
	private transient CVar _hlm_posX;
	private transient CVar _hlm_posY;
	private transient CVar _hlm_scale;
	private transient CVar _hlm_xScale;
	private transient CVar _hlm_yScale;
	private transient CVar _hlm_wrapLength;

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

		if (!_enabled) _enabled               = CVar.GetCVar("uz_hhx_ammoCounters_enabled", sb.CPlayer);
		if (!_nhm_hudLevel) _nhm_hudLevel     = CVar.GetCVar("uz_hhx_ammoCounters_nhm_hudLevel", sb.CPlayer);
		if (!_nhm_posX) _nhm_posX             = CVar.GetCVar("uz_hhx_ammoCounters_nhm_posX", sb.CPlayer);
		if (!_nhm_posY) _nhm_posY             = CVar.GetCVar("uz_hhx_ammoCounters_nhm_posY", sb.CPlayer);
		if (!_nhm_scale) _nhm_scale           = CVar.GetCVar("uz_hhx_ammoCounters_nhm_scale", sb.CPlayer);
		if (!_nhm_xScale) _nhm_xScale         = CVar.GetCVar("uz_hhx_ammoCounters_nhm_xScale", sb.CPlayer);
		if (!_nhm_yScale) _nhm_yScale         = CVar.GetCVar("uz_hhx_ammoCounters_nhm_yScale", sb.CPlayer);
		if (!_nhm_wrapLength) _nhm_wrapLength = CVar.GetCVar("uz_hhx_ammoCounters_nhm_wrapLength", sb.CPlayer);

		if (!_hlm_required) _hlm_required     = CVar.GetCVar("uz_hhx_ammoCounters_hlm_required", sb.CPlayer);
		if (!_hlm_hudLevel) _hlm_hudLevel     = CVar.GetCVar("uz_hhx_ammoCounters_hlm_hudLevel", sb.CPlayer);
		if (!_hlm_posX) _hlm_posX             = CVar.GetCVar("uz_hhx_ammoCounters_hlm_posX", sb.CPlayer);
		if (!_hlm_posY) _hlm_posY             = CVar.GetCVar("uz_hhx_ammoCounters_hlm_posY", sb.CPlayer);
		if (!_hlm_scale) _hlm_scale           = CVar.GetCVar("uz_hhx_ammoCounters_hlm_scale", sb.CPlayer);
		if (!_hlm_xScale) _hlm_xScale         = CVar.GetCVar("uz_hhx_ammoCounters_hlm_xScale", sb.CPlayer);
		if (!_hlm_yScale) _hlm_yScale         = CVar.GetCVar("uz_hhx_ammoCounters_hlm_yScale", sb.CPlayer);
		if (!_hlm_wrapLength) _hlm_wrapLength = CVar.GetCVar("uz_hhx_ammoCounters_hlm_wrapLength", sb.CPlayer);

		if (!_nhm_bgRef) _nhm_bgRef           = CVar.GetCVar("uz_hhx_ammoCounters_bg_nhm_ref", sb.CPlayer);
		if (!_nhm_bgPosX) _nhm_bgPosX         = CVar.GetCVar("uz_hhx_ammoCounters_bg_nhm_posX", sb.CPlayer);
		if (!_nhm_bgPosY) _nhm_bgPosY         = CVar.GetCVar("uz_hhx_ammoCounters_bg_nhm_posY", sb.CPlayer);
		if (!_nhm_bgScale) _nhm_bgScale       = CVar.GetCVar("uz_hhx_ammoCounters_bg_nhm_scale", sb.CPlayer);
		if (!_hlm_bgRef) _hlm_bgRef           = CVar.GetCVar("uz_hhx_ammoCounters_bg_hlm_ref", sb.CPlayer);
		if (!_hlm_bgPosX) _hlm_bgPosX         = CVar.GetCVar("uz_hhx_ammoCounters_bg_hlm_posX", sb.CPlayer);
		if (!_hlm_bgPosY) _hlm_bgPosY         = CVar.GetCVar("uz_hhx_ammoCounters_bg_hlm_posY", sb.CPlayer);
		if (!_hlm_bgScale) _hlm_bgScale       = CVar.GetCVar("uz_hhx_ammoCounters_bg_hlm_scale", sb.CPlayer);
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
		
		int   posX       = hasHelmet ? _hlm_posX.GetInt()       : _nhm_posX.GetInt();
		int   posY       = hasHelmet ? _hlm_posY.GetInt()       : _nhm_posY.GetInt();
		float scale      = hasHelmet ? _hlm_scale.GetFloat()    : _nhm_scale.GetFloat();
		float xScale     = hasHelmet ? _hlm_xScale.GetFloat()   : _nhm_xScale.GetFloat();
		float yScale     = hasHelmet ? _hlm_yScale.GetFloat()   : _nhm_yScale.GetFloat();
		int   wrapLength = hasHelmet ? _hlm_wrapLength.getInt() : _nhm_wrapLength.GetInt();

		if (AutomapActive) {
			DrawAmmoCounters(sb, -8, -18, 0, wrapLength, scale);
		} else if (CheckCommonStuff(sb, state, ticFrac)) {

			string bgRef   = hasHelmet ? _hlm_bgRef.GetString()  : _nhm_bgRef.GetString();
			int    bgPosX  = hasHelmet ? _hlm_bgPosX.GetInt()    : _nhm_bgPosX.GetInt();
			int    bgPosY  = hasHelmet ? _hlm_bgPosY.GetInt()    : _nhm_bgPosY.GetInt();
			float  bgScale = hasHelmet ? _hlm_bgScale.GetFloat() : _nhm_bgScale.GetFloat();

			// Draw HUD Element Background Image if it's defined
			sb.DrawImage(
				bgRef,
				(posX + bgPosX, posY + bgPosY),
				sb.DI_SCREEN_RIGHT_BOTTOM|sb.DI_ITEM_RIGHT_BOTTOM,
				scale: (scale * bgScale, scale * bgScale)
			);

			DrawAmmoCounters(sb, posX, posY, wrapLength, scale, xScale, yScale);
		}
	}
	
	void DrawAmmoCounters(HCStatusbar sb, int posX, int posY, int wrapLength = 0, float scale = 1., float xScale = 1., float yScale = 1.) {
	
		int   wrap = wrapLength > 0 ? wrapLength : sb.SBAR_MAXAMMOCOLS;
		actor cp   = sb.cplayer.mo;
		int   ii   = 0;
		
		for(int i = 0; i < sb.ammosprites.size(); i++){
			let count = cp.countinv(sb.ammotypes[i]);
			if(count) {
				int row   = (ii / wrap) * (sb.SBAR_AMMOROW + 2);
				int col   = (ii % wrap) * (sb.SBAR_AMMOROW + 2);
			
				Vector2 coords = (posX - (col * scale) - (row * xScale), posY - (row * scale) - (col * yScale));

				sb.DrawImage(
					sb.ammosprites[i],
					coords,
					sb.DI_SCREEN_RIGHT_BOTTOM|sb.DI_ITEM_RIGHT_BOTTOM,
					scale: (sb.ammoscales[i] * scale, sb.ammoscales[i] * scale)
				);

				sb.DrawString(
					sb.pnewsmallfont,
					""..count,
					(coords.x + 2, coords.y),
					sb.DI_SCREEN_RIGHT_BOTTOM|sb.DI_ITEM_RIGHT_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT,
					Font.CR_OLIVE,
					scale: (0.5 * scale, 0.5 * scale)
				);

				ii++;
			}
		}

		sb.bigitemyofs = -((ii - 1) / sb.SBAR_MAXAMMOCOLS) * sb.SBAR_AMMOROW - 26;
	}
}
