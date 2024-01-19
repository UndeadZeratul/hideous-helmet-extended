class UZWeaponStash : HUDWeaponStash {

    private Service _HHFunc;

    private transient CVar _enabled;
    private transient CVar _font;
    private transient CVar _fontColor;
    private transient CVar _fontScale;

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

    private transient string _prevFont;
    private transient HUDFont _hudFont;

    override void Tick(HCStatusbar sb) {
        if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

        if (!_enabled) _enabled               = CVar.GetCVar("uz_hhx_weaponStash_enabled", sb.CPlayer);
        if (!_font) _font                     = CVar.GetCVar("uz_hhx_weaponStash_font", sb.CPlayer);
        if (!_fontColor) _fontColor           = CVar.GetCVar("uz_hhx_weaponStash_fontColor", sb.CPlayer);
        if (!_fontScale) _fontScale           = CVar.GetCVar("uz_hhx_weaponStash_fontScale", sb.CPlayer);

        if (!_nhm_hudLevel) _nhm_hudLevel     = CVar.GetCVar("uz_hhx_weaponStash_nhm_hudLevel", sb.CPlayer);
        if (!_nhm_posX) _nhm_posX             = CVar.GetCVar("uz_hhx_weaponStash_nhm_posX", sb.CPlayer);
        if (!_nhm_posY) _nhm_posY             = CVar.GetCVar("uz_hhx_weaponStash_nhm_posY", sb.CPlayer);
        if (!_nhm_scale) _nhm_scale           = CVar.GetCVar("uz_hhx_weaponStash_nhm_scale", sb.CPlayer);
        if (!_nhm_xScale) _nhm_xScale         = CVar.GetCVar("uz_hhx_weaponStash_nhm_xScale", sb.CPlayer);
        if (!_nhm_yScale) _nhm_yScale         = CVar.GetCVar("uz_hhx_weaponStash_nhm_yScale", sb.CPlayer);
        if (!_nhm_wrapLength) _nhm_wrapLength = CVar.GetCVar("uz_hhx_weaponStash_nhm_wrapLength", sb.CPlayer);

        if (!_hlm_required) _hlm_required     = CVar.GetCVar("uz_hhx_weaponStash_hlm_required", sb.CPlayer);
        if (!_hlm_hudLevel) _hlm_hudLevel     = CVar.GetCVar("uz_hhx_weaponStash_hlm_hudLevel", sb.CPlayer);
        if (!_hlm_posX) _hlm_posX             = CVar.GetCVar("uz_hhx_weaponStash_hlm_posX", sb.CPlayer);
        if (!_hlm_posY) _hlm_posY             = CVar.GetCVar("uz_hhx_weaponStash_hlm_posY", sb.CPlayer);
        if (!_hlm_scale) _hlm_scale           = CVar.GetCVar("uz_hhx_weaponStash_hlm_scale", sb.CPlayer);
        if (!_hlm_xScale) _hlm_xScale         = CVar.GetCVar("uz_hhx_weaponStash_hlm_xScale", sb.CPlayer);
        if (!_hlm_yScale) _hlm_yScale         = CVar.GetCVar("uz_hhx_weaponStash_hlm_yScale", sb.CPlayer);
        if (!_hlm_wrapLength) _hlm_wrapLength = CVar.GetCVar("uz_hhx_weaponStash_hlm_wrapLength", sb.CPlayer);

        if (!_nhm_bgRef) _nhm_bgRef           = CVar.GetCVar("uz_hhx_weaponStash_bg_nhm_ref", sb.CPlayer);
        if (!_nhm_bgPosX) _nhm_bgPosX         = CVar.GetCVar("uz_hhx_weaponStash_bg_nhm_posX", sb.CPlayer);
        if (!_nhm_bgPosY) _nhm_bgPosY         = CVar.GetCVar("uz_hhx_weaponStash_bg_nhm_posY", sb.CPlayer);
        if (!_nhm_bgScale) _nhm_bgScale       = CVar.GetCVar("uz_hhx_weaponStash_bg_nhm_scale", sb.CPlayer);
        if (!_hlm_bgRef) _hlm_bgRef           = CVar.GetCVar("uz_hhx_weaponStash_bg_hlm_ref", sb.CPlayer);
        if (!_hlm_bgPosX) _hlm_bgPosX         = CVar.GetCVar("uz_hhx_weaponStash_bg_hlm_posX", sb.CPlayer);
        if (!_hlm_bgPosY) _hlm_bgPosY         = CVar.GetCVar("uz_hhx_weaponStash_bg_hlm_posY", sb.CPlayer);
        if (!_hlm_bgScale) _hlm_bgScale       = CVar.GetCVar("uz_hhx_weaponStash_bg_hlm_scale", sb.CPlayer);

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
        
        int   posX       = hasHelmet ? _hlm_posX.GetInt()     : _nhm_posX.GetInt();
        int   posY       = hasHelmet ? _hlm_posY.GetInt()     : _nhm_posY.GetInt();
        float scale      = hasHelmet ? _hlm_scale.GetFloat()  : _nhm_scale.GetFloat();
        float xScale     = hasHelmet ? _hlm_xScale.GetFloat() : _nhm_xScale.GetFloat();
        float yScale     = hasHelmet ? _hlm_yScale.GetFloat() : _nhm_yScale.GetFloat();
        int   wrapLength = hasHelmet ? _hlm_wrapLength.getInt() : _nhm_wrapLength.GetInt();

        if (AutomapActive) {
            DrawWeaponStash(sb, sb.DI_SCREEN_RIGHT_BOTTOM|sb.DI_ITEM_RIGHT, -8, -48, xScale: 0., yScale: 0.);
        } else if (CheckCommonStuff(sb, state, ticFrac)) {

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

            DrawWeaponStash(sb, sb.DI_SCREEN_LEFT_BOTTOM|sb.DI_ITEM_LEFT, posX, posY, wrapLength, scale, xScale, yScale);
        }
    }

    void DrawWeaponStash(HCStatusbar sb, int flags, int posX, int posY, int wrapLength = 0, float scale = 1., float xScale = 1., float yScale = 1.) {

        int wrap = wrapLength > 0 ? wrapLength : 1;

        for(int i = sb.wepsprites.size() - 1; i >= 0; i--) {

            int row = (i / wrap) * 24;
            int col = (i % wrap) * 32;
        
            Vector2 coords = (posX + (col * scale) - (row * xScale), posY - (row * scale) - (col * yScale));

            // Draw the weapon sprite itself
            sb.DrawImage(
                sb.wepSprites[i],
                coords,
                flags|sb.DI_ITEM_BOTTOM,
                scale: (sb.wepSpriteScales[i] * scale, sb.wepSpriteScales[i] * scale)
            );

            // Draw the number of copies of that weapon in the player's inventory,
            // should they be carrying more than one
            int count = sb.wepSpriteCounts[i];
            if(count > 1) {
                float fontScale = _fontScale.GetFloat();
                sb.DrawString(
                    _hudFont,
                    count.."x",
                    (coords.x - (flags & sb.DI_ITEM_RIGHT ? 10 : 2), coords.y - 3),
                    flags|sb.DI_ITEM_BOTTOM|sb.DI_TEXT_ALIGN_LEFT,
                    _fontColor.GetInt(),
                    scale: (fontScale * scale, fontScale * scale)
                );
            }
        }
    }
}
