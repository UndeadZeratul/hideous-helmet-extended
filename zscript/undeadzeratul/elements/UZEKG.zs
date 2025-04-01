class UZEKG : HUDEKG {

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
    private transient CVar _hlm_length;
    private transient CVar _nhm_hudLevel;
    private transient CVar _nhm_posX;
    private transient CVar _nhm_posY;
    private transient CVar _nhm_scale;
    private transient CVar _nhm_length;

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

    private transient Array<int> _healthBars;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "ekg";

        _HHFunc = ServiceIterator.Find("HHFunc").Next();
    }

    override void Tick(HCStatusbar sb) {
        if (!_easterEggs) _easterEggs     = CVar.GetCVar("uz_hhx_eastereggs_enabled", sb.CPlayer);

        if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_ekg_enabled", sb.CPlayer);

        if (!_font) _font                 = CVar.GetCVar("uz_hhx_ekg_font", sb.CPlayer);
        if (!_fontScale) _fontScale       = CVar.GetCVar("uz_hhx_ekg_fontScale", sb.CPlayer);

        if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_ekg_hlm_required", sb.CPlayer);
        if (!_hlm_hudLevel) _hlm_hudLevel = CVar.GetCVar("uz_hhx_ekg_hlm_hudLevel", sb.CPlayer);
        if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_ekg_hlm_posX", sb.CPlayer);
        if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_ekg_hlm_posY", sb.CPlayer);
        if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_ekg_hlm_scale", sb.CPlayer);
        if (!_hlm_length) _hlm_length     = CVar.GetCVar("uz_hhx_ekg_hlm_length", sb.CPlayer);
        if (!_nhm_hudLevel) _nhm_hudLevel = CVar.GetCVar("uz_hhx_ekg_nhm_hudLevel", sb.CPlayer);
        if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_ekg_nhm_posX", sb.CPlayer);
        if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_ekg_nhm_posY", sb.CPlayer);
        if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_ekg_nhm_scale", sb.CPlayer);
        if (!_nhm_length) _nhm_length     = CVar.GetCVar("uz_hhx_ekg_nhm_length", sb.CPlayer);

        if (!_nhm_bgRef) _nhm_bgRef       = CVar.GetCVar("uz_hhx_ekg_bg_nhm_ref", sb.CPlayer);
        if (!_nhm_bgPosX) _nhm_bgPosX     = CVar.GetCVar("uz_hhx_ekg_bg_nhm_posX", sb.CPlayer);
        if (!_nhm_bgPosY) _nhm_bgPosY     = CVar.GetCVar("uz_hhx_ekg_bg_nhm_posY", sb.CPlayer);
        if (!_nhm_bgScale) _nhm_bgScale   = CVar.GetCVar("uz_hhx_ekg_bg_nhm_scale", sb.CPlayer);
        if (!_hlm_bgRef) _hlm_bgRef       = CVar.GetCVar("uz_hhx_ekg_bg_hlm_ref", sb.CPlayer);
        if (!_hlm_bgPosX) _hlm_bgPosX     = CVar.GetCVar("uz_hhx_ekg_bg_hlm_posX", sb.CPlayer);
        if (!_hlm_bgPosY) _hlm_bgPosY     = CVar.GetCVar("uz_hhx_ekg_bg_hlm_posY", sb.CPlayer);
        if (!_hlm_bgScale) _hlm_bgScale   = CVar.GetCVar("uz_hhx_ekg_bg_hlm_scale", sb.CPlayer);

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

        int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
        int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
        float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();
        int length = hasHelmet ? _hlm_length.GetInt() : _nhm_length.GetInt();

        float fontScale = _fontScale.GetFloat();
        int debugTran = sb.hpl.health > 70
            ? Font.CR_OLIVE
            : (sb.hpl.health > 33
                ? Font.CR_GOLD
                : Font.CR_RED
              );
        Vector2 debugScale = (fontScale * scale, fontScale * scale);

        let formattedValue = sb.FormatNumber(sb.hpl.health);

        // If Easter Eggs are enabled or it's April 1st, nice.
        if (
            (_easterEggs && _easterEggs.GetBool())
            || SystemTime.Format("%m-%d", SystemTime.Now()) == "04-01"
        ) {
            formattedValue.replace("69", "nice");
            formattedValue.replace("6.9", "ni.ce");
        }

        if (AutomapActive) {
            if(hd_debug || hd_nobleed) {

                sb.drawstring(
                    _hudFont,
                    formattedValue,
                    (34, -24),
                    sb.DI_BOTTOMLEFT|sb.DI_TEXT_ALIGN_CENTER,
                    debugTran,
                    scale: debugScale
                );
            } else {
                DrawEKG(sb, state, ticFrac, 40, -24, sb.DI_BOTTOMLEFT, 1., length);
            }
        } else if (CheckCommonStuff(sb, state, ticFrac)) {


            string bgRef   = hasHelmet ? _hlm_bgRef.GetString()  : _nhm_bgRef.GetString();
            int    bgPosX  = hasHelmet ? _hlm_bgPosX.GetInt()    : _nhm_bgPosX.GetInt();
            int    bgPosY  = hasHelmet ? _hlm_bgPosY.GetInt()    : _nhm_bgPosY.GetInt();
            float  bgScale = hasHelmet ? _hlm_bgScale.GetFloat() : _nhm_bgScale.GetFloat();

            // Draw HUD Element Background Image if it's defined
            sb.DrawImage(
                bgRef,
                (posX + bgPosX, posY + bgPosY),
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_CENTER,
                scale: (scale * bgScale, scale * bgScale)
            );

            if(hd_debug || hd_nobleed) {
                sb.drawstring(
                    _hudFont,
                    formattedValue,
                    (posX, posY - (_hudFont.mFont.GetHeight() / 2) * fontScale * scale),
                    sb.DI_TEXT_ALIGN_CENTER|sb.DI_SCREEN_CENTER_BOTTOM,
                    debugTran,
                    scale: debugScale
                );
            } else {
                DrawEKG(sb, state, ticFrac, posX, posY, sb.DI_SCREEN_CENTER_BOTTOM, scale, length);
            }
        }
    }

    private void DrawEKG(HCStatusbar sb, int state, double ticFrac, int posX, int posY, int flags, float scale, int length) {
        Color sbcolour = sb.hpl.player.GetDisplayColor();

        if (!sb.hpl.beatcount) {
            int err = random[heart](0, max(0,((100 - sb.hpl.health) >> 3)));

            _healthBars.insert(0, clamp(18 - (sb.hpl.bloodloss >> 7) - (err >> 2), 1, 18));
            _healthBars.insert(0, (sb.hpl.inpain ? random[heart](1, 7) : 1) + err + random[heart](0, (sb.hpl.bloodpressure >> 3)));

            while (_healthBars.Size() > length) _healthBars.Pop();
        }

        if (sb.hpl.health <= 0) for (int i = 0; i < length; i++) _healthBars[i] = 1;

        for (int i = 0; i < _healthBars.Size(); i++) {
            int alf = (i&1) ? 128 : 255;

            sb.fill(
                (
                    sb.hpl.health > 70
                        ? color(alf,     sbcolour.r, sbcolour.g, sbcolour.b)
                        : sb.hpl.health > 33
                            ? color(alf, 240,        210,        10)
                            : color(alf, 220,        0,          0)
                ),
                posX + (i * scale) - (length >> 2),
                (posY - (_healthBars[i] * 0.3 * scale)),
                0.8 * scale,
                _healthBars[i] * 0.6 * scale,
                flags|(sb.hpl.health > 70 ? sb.DI_TRANSLATABLE : 0)
            );
        }
    }
}
