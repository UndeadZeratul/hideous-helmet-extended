class UZEncumbrance : HUDEncumbrance {

    private transient Service _HHFunc;

    private transient CVar _easterEggs;

    private transient CVar _enabled;

    private transient CVar _font;
    private transient CVar _fontScale;
    
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

    private transient string _prevFont;
    private transient HUDFont _hudFont;

    override void Init(HCStatusbar sb) {
        super.Init(sb);

        _HHFunc = ServiceIterator.Find("HHFunc").Next();
    }

    override void Tick(HCStatusbar sb) {
        if (!_easterEggs) _easterEggs     = CVar.GetCVar("uz_hhx_eastereggs_enabled", sb.CPlayer);

        if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_encumbrance_enabled", sb.CPlayer);

        if (!_font) _font                 = CVar.GetCVar("uz_hhx_encumbrance_font", sb.CPlayer);
        if (!_fontScale) _fontScale       = CVar.GetCVar("uz_hhx_encumbrance_fontScale", sb.CPlayer);

        if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_encumbrance_hlm_required", sb.CPlayer);
        if (!_hlm_hudLevel) _hlm_hudLevel = CVar.GetCVar("uz_hhx_encumbrance_hlm_hudLevel", sb.CPlayer);
        if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_encumbrance_hlm_posX", sb.CPlayer);
        if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_encumbrance_hlm_posY", sb.CPlayer);
        if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_encumbrance_hlm_scale", sb.CPlayer);    
        if (!_nhm_hudLevel) _nhm_hudLevel = CVar.GetCVar("uz_hhx_encumbrance_nhm_hudLevel", sb.CPlayer);
        if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_encumbrance_nhm_posX", sb.CPlayer);
        if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_encumbrance_nhm_posY", sb.CPlayer);
        if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_encumbrance_nhm_scale", sb.CPlayer);

        if (!_nhm_bgRef) _nhm_bgRef       = CVar.GetCVar("uz_hhx_encumbrance_bg_nhm_ref", sb.CPlayer);
        if (!_nhm_bgPosX) _nhm_bgPosX     = CVar.GetCVar("uz_hhx_encumbrance_bg_nhm_posX", sb.CPlayer);
        if (!_nhm_bgPosY) _nhm_bgPosY     = CVar.GetCVar("uz_hhx_encumbrance_bg_nhm_posY", sb.CPlayer);
        if (!_nhm_bgScale) _nhm_bgScale   = CVar.GetCVar("uz_hhx_encumbrance_bg_nhm_scale", sb.CPlayer);
        if (!_hlm_bgRef) _hlm_bgRef       = CVar.GetCVar("uz_hhx_encumbrance_bg_hlm_ref", sb.CPlayer);
        if (!_hlm_bgPosX) _hlm_bgPosX     = CVar.GetCVar("uz_hhx_encumbrance_bg_hlm_posX", sb.CPlayer);
        if (!_hlm_bgPosY) _hlm_bgPosY     = CVar.GetCVar("uz_hhx_encumbrance_bg_hlm_posY", sb.CPlayer);
        if (!_hlm_bgScale) _hlm_bgScale   = CVar.GetCVar("uz_hhx_encumbrance_bg_hlm_scale", sb.CPlayer);

        string newFont = _font.GetString();
        if (_prevFont != newFont) {
            let font = Font.FindFont(newFont);
            _hudFont = HUDFont.create(font ? font : Font.FindFont('NewSmallFont'));
            _prevFont = newFont;
        }
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

        if (CheckCommonStuff(sb, state, ticFrac)) {

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
                sb.DI_SCREEN_LEFT_BOTTOM|sb.DI_ITEM_LEFT,
                scale: (scale * bgScale, scale * bgScale)
            );

            if(sb.hpl.enc) {
                double pocketenc = sb.hpl.pocketenc;

                // Encumbrance Bulk Value
                float fontScale = _fontScale.GetFloat();

                // TODO: cast to int?  tie to CVAR?
                let formattedValue = sb.FormatNumber(sb.hpl.enc);

                // If Easter Eggs are enabled or it's April 1st, nice.
                if (
                    (_easterEggs && _easterEggs.GetBool())
                    || SystemTime.Format("%m-%d", SystemTime.Now()) == "04-01"
                ) {
                    formattedValue.replace("69", "nice");
                    formattedValue.replace("6.9", "ni.ce");
                }

                sb.drawstring(
                    _hudFont,
                    formattedValue,
                    (posX + (4 * fontScale * scale), posY - ((_hudFont.mFont.GetHeight() >> 1) * fontScale * scale)),
                    sb.DI_TEXT_ALIGN_LEFT|sb.DI_SCREEN_LEFT_BOTTOM,
                    sb.hpl.overloaded < 0.8
                        ? Font.CR_OLIVE 
                        : sb.hpl.overloaded > 1.6
                            ? Font.CR_RED
                            : Font.CR_GOLD,
                    scale: (fontScale * scale, fontScale * scale)
                );

                // Encumbrance Bar Border
                sb.fill(
                    color(128, 96, 96, 96),
                    posX,
                    posY,
                    scale,
                    -scale,
                    sb.DI_SCREEN_LEFT_BOTTOM|sb.DI_ITEM_LEFT
                );
                sb.fill(
                    color(128, 96, 96, 96),
                    posX + scale,
                    posY,
                    scale,
                    -20 * scale,
                    sb.DI_SCREEN_LEFT_BOTTOM|sb.DI_ITEM_LEFT
                );
                sb.fill(
                    color(128, 96, 96, 96),
                    posX - scale,
                    posY,
                    scale,
                    -20 * scale,
                    sb.DI_SCREEN_LEFT_BOTTOM|sb.DI_ITEM_LEFT
                );

                // Encumbrance Bar Fill
                sb.drawrect(
                    posX,
                    posY - scale,
                    scale,
                    (-min(sb.hpl.maxpocketspace, pocketenc) * 19 / sb.hpl.maxpocketspace) * scale,
                    sb.DI_SCREEN_LEFT_BOTTOM|sb.DI_ITEM_LEFT
                );

                // Over-Encumbrance Bar Fill
                bool overenc = sb.hpl.flip && pocketenc > sb.hpl.maxpocketspace;

                sb.fill(
                    overenc ? color(255,216,194,42) : color(128,96,96,96),
                    posX,
                    posY - (19 * scale),
                    scale,
                    -(overenc ? 3 : 1) * scale,
                    sb.DI_SCREEN_LEFT_BOTTOM|sb.DI_ITEM_LEFT
                );
            }
        }
    }
}
