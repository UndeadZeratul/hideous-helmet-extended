class UZPersonalShieldGeneratorOverride : HCItemOverride {

    private transient Service _HHFunc;
    private transient Service _PSGService;

    private transient CVar _enabled;
    private transient CVar _font;
    private transient CVar _fontColor;
    private transient CVar _fontScale;

    private transient CVar _nhm_hudLevel;
    private transient CVar _nhm_posX;
    private transient CVar _nhm_posY;
    private transient CVar _nhm_scale;

    private transient CVar _hlm_required;
    private transient CVar _hlm_hudLevel;
    private transient CVar _hlm_posX;
    private transient CVar _hlm_posY;
    private transient CVar _hlm_scale;

    private transient CVar _nhm_bgRef;
    private transient CVar _nhm_bgPosX;
    private transient CVar _nhm_bgPosY;
    private transient CVar _nhm_bgScale;
    private transient CVar _hlm_bgRef;
    private transient CVar _hlm_bgPosX;
    private transient CVar _hlm_bgPosY;
    private transient CVar _hlm_bgScale;

    private transient string _prevFont;
    private transient HUDFont _hudFont;

    private transient HDWeapon _sGen;

    override void Init(HCStatusbar sb) {
        Priority     = 1;
        OverrideType = HCOVERRIDETYPE_ITEM;
    }

    override bool CheckItem(Inventory item) {
        return (!_enabled || _enabled.GetBool()) && item.GetClassName() == "HDPersonalShield";
    }

    override void Tick(HCStatusbar sb) {
        if (!_HHFunc) _HHFunc             = ServiceIterator.Find("HHFunc").Next();
        if (!_PSGService) _PSGService     = ServiceIterator.Find("HDPersonalShieldGeneratorService").Next();

        if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_personalShieldGenerator_enabled", sb.CPlayer);
        if (!_font) _font                 = CVar.GetCVar("uz_hhx_personalShieldGenerator_font", sb.CPlayer);
        if (!_fontColor) _fontColor       = CVar.GetCVar("uz_hhx_personalShieldGenerator_fontColor", sb.CPlayer);
        if (!_fontScale) _fontScale       = CVar.GetCVar("uz_hhx_personalShieldGenerator_fontScale", sb.CPlayer);

        if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_personalShieldGenerator_hlm_required", sb.CPlayer);
        if (!_hlm_hudLevel) _hlm_hudLevel = CVar.GetCVar("uz_hhx_personalShieldGenerator_hlm_hudLevel", sb.CPlayer);
        if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_personalShieldGenerator_hlm_posX", sb.CPlayer);
        if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_personalShieldGenerator_hlm_posY", sb.CPlayer);
        if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_personalShieldGenerator_hlm_scale", sb.CPlayer);
        if (!_nhm_hudLevel) _nhm_hudLevel = CVar.GetCVar("uz_hhx_personalShieldGenerator_nhm_hudLevel", sb.CPlayer);
        if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_personalShieldGenerator_nhm_posX", sb.CPlayer);
        if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_personalShieldGenerator_nhm_posY", sb.CPlayer);
        if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_personalShieldGenerator_nhm_scale", sb.CPlayer);

        if (!_nhm_bgRef) _nhm_bgRef       = CVar.GetCVar("uz_hhx_personalShieldGenerator_bg_nhm_ref", sb.CPlayer);
        if (!_nhm_bgPosX) _nhm_bgPosX     = CVar.GetCVar("uz_hhx_personalShieldGenerator_bg_nhm_posX", sb.CPlayer);
        if (!_nhm_bgPosY) _nhm_bgPosY     = CVar.GetCVar("uz_hhx_personalShieldGenerator_bg_nhm_posY", sb.CPlayer);
        if (!_nhm_bgScale) _nhm_bgScale   = CVar.GetCVar("uz_hhx_personalShieldGenerator_bg_nhm_scale", sb.CPlayer);
        if (!_hlm_bgRef) _hlm_bgRef       = CVar.GetCVar("uz_hhx_personalShieldGenerator_bg_hlm_ref", sb.CPlayer);
        if (!_hlm_bgPosX) _hlm_bgPosX     = CVar.GetCVar("uz_hhx_personalShieldGenerator_bg_hlm_posX", sb.CPlayer);
        if (!_hlm_bgPosY) _hlm_bgPosY     = CVar.GetCVar("uz_hhx_personalShieldGenerator_bg_hlm_posY", sb.CPlayer);
        if (!_hlm_bgScale) _hlm_bgScale   = CVar.GetCVar("uz_hhx_personalShieldGenerator_bg_hlm_scale", sb.CPlayer);

        if (!_sGen) _sGen                 = HDWeapon(sb.hpl.FindInventory("HDPersonalShieldGenerator"));

        string newFont = _font.GetString();
        if (_prevFont != newFont) {
            let font = Font.FindFont(newFont);
            _hudFont = HUDFont.create(font ? font : Font.FindFont('NewSmallFont'));
            _prevFont = newFont;
        }
    }

    override void DrawHUDStuff(HCStatusbar sb, Inventory item, int hdFlags, int gzFlags) {
        bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);
        int  hudLevel  = hasHelmet ? _hlm_hudLevel.GetInt() : _nhm_hudLevel.GetInt();

        HDDamageHandler shield = HDDamageHandler(item);

        if (
            !_enabled.GetBool()
            || (!hasHelmet && _hlm_required.GetBool())
            || HDSpectator(sb.hpl)
            || !(sb.HUDLevel >= hudLevel)
            || AutomapActive
            || sb.CPlayer.mo != sb.CPlayer.Camera
            || sb.hpl.Health < 1
            || !_sGen
            || !shield
        ) return;

        // if (CheckCommonStuff(sb, state, ticFrac)) {

        int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
        int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
        float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();

        string bgRef   = hasHelmet ? _hlm_bgRef.GetString()  : _nhm_bgRef.GetString();
        int    bgPosX  = hasHelmet ? _hlm_bgPosX.GetInt()    : _nhm_bgPosX.GetInt();
        int    bgPosY  = hasHelmet ? _hlm_bgPosY.GetInt()    : _nhm_bgPosY.GetInt();
        float  bgScale = hasHelmet ? _hlm_bgScale.GetFloat() : _nhm_bgScale.GetFloat();

        float fontScale = _fontScale.GetFloat();

        // Draw HUD Element Background Image if it's defined
        sb.DrawImage(
            bgRef,
            (posX + bgPosX, posY + bgPosY),
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_LEFT_BOTTOM,
            scale: (scale * bgScale, scale * bgScale)
        );

        
        // Taken from HDPersonalShield.DrawHUDStuff()
        // -----------------------------
        
        // Draw Pickup Sprite
		sb.DrawImage(
            _sGen.GetPickupSprite(),
            (posX, posY), // (100, -3),
            gzFlags|sb.DI_ITEM_LEFT_BOTTOM,
            box: (20 * scale, -1),
            scale: (scale, scale)
        );

        // Draw Shield Mode
		sb.DrawString(
            _hudFont,
            _sGen.weaponStatus[8] == 0 // PSProp_Mode
                ? "\c[Green]360\c-"
                : "\c[Red]120\c-",
            (posX + (20 * scale), posY + (-15 * scale)), // (120, -18),
            gzflags|sb.DI_TEXT_ALIGN_LEFT,
            _fontColor.GetInt(),
            scale: (scale * fontScale, scale * fontScale)
        );

        // Draw Flux Values
		string colSoft = IsShieldEnabled(sb.hpl) ? "\c[DarkGreen]" : (_sGen.weaponStatus[0]&16 ? "\c[DarkRed]" : "\c[Yellow]"); // PSProp_Flags, PSF_Overloaded
		string colHard = IsShieldEnabled(sb.hpl) ? "\c[Green]" : (_sGen.weaponStatus[0]&16 ? "\c[Red]" : "\c[Gold]");           // PSProp_Flags, PSF_Overloaded
		sb.DrawString(
            _hudFont,
			String.Format(
                "%s%i\c-/%s%i\c-/\c[Cyan]%i\c-",
                colSoft, _sGen.weaponStatus[5], // PSProp_Flux
                colHard, _sGen.weaponStatus[6], // PSProp_HardFlux
                GetShieldFluxCap(sb.hpl)
            ),
			(posX + (20 * scale), posY + (-7 * scale)), // (120, -10),
            gzflags|sb.DI_TEXT_ALIGN_LEFT,
            _fontColor.GetInt(),
            scale: (scale * fontScale, scale * fontScale)
        );

        // Draw Installed Batteries
		for (int i = 0; i < 3; i++) {
			int bat = _sGen.weaponStatus[2 + i]; // PSProp_Battery1, PSProp_Battery2, PSProp_Battery3
			if (bat > -1) {
				sb.DrawImage(
                    GetBatteryColor(bat),
                    (posX + (-1 * scale), posY + ((-20 + (8 * i)) * scale)), // (99, -23 + 8 * i),
                    gzFlags|sb.DI_ITEM_RIGHT|sb.DI_ITEM_VCENTER,
                    box: (-1 * scale, 7 * scale),
                    scale: (scale, scale)
                );
			}
		}
    }

    private bool IsShieldEnabled(PlayerPawn p) {
        return _PSGService && _PSGService.GetIntUI("GeneratorEnabled", objectArg: p);
    }

    private int GetShieldFluxCap(PlayerPawn p) {
        return _PSGService ? _PSGService.GetIntUI("GeneratorFluxCap", objectArg: p) : -1;
    }


    // Taken from AceCore.GetBatteryColor()
    // TODO: Hoist out into HDCore?
	private string, int, Color GetBatteryColor(int charge) {
		if      (charge > 13) return "CELLA0", Font.CR_GREEN,  Color(255,   0, 255,  0);
		else if (charge >  6) return "CELLB0", Font.CR_YELLOW, Color(255, 255, 255,  0);
		else if (charge >  0) return "CELLC0", Font.CR_RED,    Color(255, 255,   0,  0);
		else                  return "CELLD0", Font.CR_GRAY,   Color(255,  64,  64, 64);
	}
}
