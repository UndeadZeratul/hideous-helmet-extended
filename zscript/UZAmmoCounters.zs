class UZAmmoCounters : HUDAmmoCounters {

	private Service _HHFunc;

	private transient CVar _enabled;
	private transient CVar _hlm_required;

	private transient CVar _hlm_posX;
	private transient CVar _hlm_posY;
	private transient CVar _hlm_scale;
	private transient CVar _nhm_posX;
	private transient CVar _nhm_posY;
	private transient CVar _nhm_scale;

	override void Tick(HCStatusbar sb) {
		if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

		if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_ammoCounters_enabled", sb.CPlayer);
		if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_ammoCounters_hlm_required", sb.CPlayer);
		if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_ammoCounters_hlm_posX", sb.CPlayer);
		if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_ammoCounters_hlm_posY", sb.CPlayer);
		if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_ammoCounters_hlm_scale", sb.CPlayer);
		if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_ammoCounters_nhm_posX", sb.CPlayer);
		if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_ammoCounters_nhm_posY", sb.CPlayer);
		if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_ammoCounters_nhm_scale", sb.CPlayer);
	}

	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
		bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);

		if (
			!_enabled.GetBool()
			|| (!hasHelmet && _hlm_required.GetBool())
			|| HDSpectator(sb.hpl)
		) return;
		
		int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
		int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
		float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();

		if (AutomapActive) {
			DrawAmmoCounters(sb, -8, -18, scale);
		} else if (CheckCommonStuff(sb, state, ticFrac) && sb.HUDLevel == 2) {
			DrawAmmoCounters(sb, posX, posY, scale);
		}
	}
	
	void DrawAmmoCounters(HCStatusbar sb, int posX, int posY, float scale = 1.) {
	
		actor cp = sb.cplayer.mo;
		int   ii = 0;
		
		
		for(int i = 0; i < sb.ammosprites.size(); i++){
			let count = cp.countinv(sb.ammotypes[i]);
			if(count) {
			
				Vector2 coords = (posX - (ii % sb.SBAR_MAXAMMOCOLS) * 16, posY - (ii / sb.SBAR_MAXAMMOCOLS) * 16);

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
