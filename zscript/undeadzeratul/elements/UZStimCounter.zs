class UZStimCounter : HUDElement {

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

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "stimcounter";
	}

	override void Tick(HCStatusbar sb) {
		if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

		if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_stimCounter_enabled", sb.CPlayer);
		if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_stimCounter_hlm_required", sb.CPlayer);
		if (!_hlm_hudLevel) _hlm_hudLevel = CVar.GetCVar("uz_hhx_stimCounter_hlm_hudLevel", sb.CPlayer);
		if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_stimCounter_hlm_posX", sb.CPlayer);
		if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_stimCounter_hlm_posY", sb.CPlayer);
		if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_stimCounter_hlm_scale", sb.CPlayer);
		if (!_nhm_hudLevel) _nhm_hudLevel = CVar.GetCVar("uz_hhx_stimCounter_nhm_hudLevel", sb.CPlayer);
		if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_stimCounter_nhm_posX", sb.CPlayer);
		if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_stimCounter_nhm_posY", sb.CPlayer);
		if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_stimCounter_nhm_scale", sb.CPlayer);

		if (!_nhm_bgRef) _nhm_bgRef       = CVar.GetCVar("uz_hhx_stimCounter_bg_nhm_ref", sb.CPlayer);
		if (!_nhm_bgPosX) _nhm_bgPosX     = CVar.GetCVar("uz_hhx_stimCounter_bg_nhm_posX", sb.CPlayer);
		if (!_nhm_bgPosY) _nhm_bgPosY     = CVar.GetCVar("uz_hhx_stimCounter_bg_nhm_posY", sb.CPlayer);
		if (!_nhm_bgScale) _nhm_bgScale   = CVar.GetCVar("uz_hhx_stimCounter_bg_nhm_scale", sb.CPlayer);
		if (!_hlm_bgRef) _hlm_bgRef       = CVar.GetCVar("uz_hhx_stimCounter_bg_hlm_ref", sb.CPlayer);
		if (!_hlm_bgPosX) _hlm_bgPosX     = CVar.GetCVar("uz_hhx_stimCounter_bg_hlm_posX", sb.CPlayer);
		if (!_hlm_bgPosY) _hlm_bgPosY     = CVar.GetCVar("uz_hhx_stimCounter_bg_hlm_posY", sb.CPlayer);
		if (!_hlm_bgScale) _hlm_bgScale   = CVar.GetCVar("uz_hhx_stimCounter_bg_hlm_scale", sb.CPlayer);
    }

	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
		bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);
		int  hudLevel  = hasHelmet ? _hlm_hudLevel.GetInt() : _nhm_hudLevel.GetInt();

		if (
			!_enabled.GetBool()
			|| (!hasHelmet && _hlm_required.GetBool())
			|| HDSpectator(sb.hpl)
			|| !(sb.HUDLevel >= hudLevel)
		) return;

		if (AutomapActive) {
            DrawStimCounter(sb, 56, -22);
		} else if (CheckCommonStuff(sb, state, ticFrac)) {

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
				sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_LEFT_BOTTOM,
				scale: (scale * bgScale, scale * bgScale)
			);
            
            DrawStimCounter(sb, posX, posY, scale);
        }
    }

    void DrawStimCounter(HCStatusbar sb, int posX, int posY, float scale = 1.) {
        let stims  = sb.hpl.CountInv('HDStim');

        if(stims) {
            sb.DrawImage(
                "HLMSA0",
                (posX, posY),
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP,
                0.6,
                scale: (scale, scale)
            );

            sb.DrawString(
                sb.mIndexFont,
                sb.FormatNumber(stims / 4),
                (posX + (8 * scale), posY + scale),
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_LEFT,
                Font.CR_GREEN,
                scale: (scale, scale)
            );
        }
    }
}