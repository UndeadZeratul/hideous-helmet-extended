enum HHX_WEAPON_STATUS_STYLE {
    CHAMBER_AND_MAG,
    CHAMBER_MAG_AND_SADDLES,
    GL_RANGE_FINDER,
    CELL_WEAPON,
    BOLT_ACTION,
    CUSTOM
}

class BaseWeaponStatusOverride : HCItemOverride abstract {

    protected name weaponName;
    protected name magName;
    protected name ammoName;

    protected int magCapacity;
    
    protected string magIconFull;
    protected string magIconEmpty;
    protected string magIconFG;
    protected string magIconBG;

    protected string ammoIcon;

    protected string fireModes[7];

    protected int style;

    protected transient TextureID magFullTex;
    protected transient TextureID magEmptyTex;
    protected transient Vector2 magFullScale;
    protected transient Vector2 magEmptyScale;

    protected transient TextureID ammoTex;
    protected transient Vector2 ammoScale;

    private Service _HHFunc;

    private transient CVar _hh_hidefiremode;

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
    
    override void Init(HCStatusbar sb) {
        Priority     = 1;
        OverrideType = HCOVERRIDETYPE_WEAPON;
    }

    override bool CheckItem(Inventory item) {
        return !_enabled || _enabled.GetBool() && item.GetClassName() == weaponName;
    }

    virtual void initCvars(HCStatusBar sb) {
        if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

        if (!_hh_hidefiremode) _hh_hidefiremode = CVar.GetCVar("hh_hidefiremode", sb.CPlayer);

        if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_weaponStatus_enabled", sb.CPlayer);
        if (!_font) _font                 = CVar.GetCVar("uz_hhx_weaponStatus_font", sb.CPlayer);
        if (!_fontColor) _fontColor       = CVar.GetCVar("uz_hhx_weaponStatus_fontColor", sb.CPlayer);
        if (!_fontScale) _fontScale       = CVar.GetCVar("uz_hhx_weaponStatus_fontScale", sb.CPlayer);

        if (!_nhm_hudLevel) _nhm_hudLevel = CVar.GetCVar("uz_hhx_weaponStatus_nhm_hudLevel", sb.CPlayer);
        if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_weaponStatus_nhm_posX", sb.CPlayer);
        if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_weaponStatus_nhm_posY", sb.CPlayer);
        if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_weaponStatus_nhm_scale", sb.CPlayer);

        if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_weaponStatus_hlm_required", sb.CPlayer);
        if (!_hlm_hudLevel) _hlm_hudLevel = CVar.GetCVar("uz_hhx_weaponStatus_hlm_hudLevel", sb.CPlayer);
        if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_weaponStatus_hlm_posX", sb.CPlayer);
        if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_weaponStatus_hlm_posY", sb.CPlayer);
        if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_weaponStatus_hlm_scale", sb.CPlayer);

        if (!_nhm_bgRef) _nhm_bgRef       = CVar.GetCVar("uz_hhx_weaponStatus_bg_nhm_ref", sb.CPlayer);
        if (!_nhm_bgPosX) _nhm_bgPosX     = CVar.GetCVar("uz_hhx_weaponStatus_bg_nhm_posX", sb.CPlayer);
        if (!_nhm_bgPosY) _nhm_bgPosY     = CVar.GetCVar("uz_hhx_weaponStatus_bg_nhm_posY", sb.CPlayer);
        if (!_nhm_bgScale) _nhm_bgScale   = CVar.GetCVar("uz_hhx_weaponStatus_bg_nhm_scale", sb.CPlayer);
        if (!_hlm_bgRef) _hlm_bgRef       = CVar.GetCVar("uz_hhx_weaponStatus_bg_hlm_ref", sb.CPlayer);
        if (!_hlm_bgPosX) _hlm_bgPosX     = CVar.GetCVar("uz_hhx_weaponStatus_bg_hlm_posX", sb.CPlayer);
        if (!_hlm_bgPosY) _hlm_bgPosY     = CVar.GetCVar("uz_hhx_weaponStatus_bg_hlm_posY", sb.CPlayer);
        if (!_hlm_bgScale) _hlm_bgScale   = CVar.GetCVar("uz_hhx_weaponStatus_bg_hlm_scale", sb.CPlayer);

        string newFont = _font.GetString();
        if (_prevFont != newFont) {
            let font = Font.FindFont(newFont);
            _hudFont = HUDFont.create(font ? font : Font.FindFont('NewSmallFont'));
            _prevFont = newFont;
        }

        if (!magFullTex && magIconFull) {
            magFullTex = TexMan.CheckForTexture(magIconFull, TexMan.Type_Any);

            if (magFullTex) {
                int x, y;
                [x, y] = TexMan.GetSize(magFullTex);
                Vector2 scaledSize = TexMan.GetScaledSize(magFullTex);
                
                magFullScale = (scaledSize.x > 0 && scaledSize.y > 0)
                    ? (x / scaledSize.x, y / scaledSize.y)
                    : (0, 0);
            }
        }

        if (!magEmptyTex && magIconEmpty) {
            magEmptyTex = TexMan.CheckForTexture(magIconEmpty, TexMan.Type_Any);

            if (magEmptyTex) {
                int x, y;
                [x, y] = TexMan.GetSize(magEmptyTex);
                Vector2 scaledSize = TexMan.GetScaledSize(magEmptyTex);
                
                magEmptyScale = (scaledSize.x > 0 && scaledSize.y > 0)
                    ? (x / scaledSize.x, y / scaledSize.y)
                    : (0, 0);
            }
        }

        if (!ammoTex && ammoIcon) {
            ammoTex = TexMan.CheckForTexture(ammoIcon, TexMan.Type_Any);

            if (ammoTex) {
                int x, y;
                [x, y] = TexMan.GetSize(ammoTex);
                Vector2 scaledSize = TexMan.GetScaledSize(ammoTex);
                
                ammoScale = (scaledSize.x > 0 && scaledSize.y > 0)
                    ? (x / scaledSize.x, y / scaledSize.y)
                    : (0, 0);
            }
        }
    }

    override void Tick(HCStatusbar sb) {
        initCvars(sb);
    }

    override void DrawHUDStuff(HCStatusbar sb, Inventory item, int hdFlags, int gzFlags) {
        initCvars(sb);
        
        bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);
        int  hudLevel  = hasHelmet ? _hlm_hudLevel.GetInt() : _nhm_hudLevel.GetInt();
        
        if (_HHFunc && _HHFunc.GetIntUI("CheckWeaponStuff", objectArg: sb)) {

            let hdw = HDWeapon(item);

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

            DrawWeaponStatus(sb, hdw, posX, posY, scale, _hudFont, _fontColor.GetInt(), _fontScale.GetFloat());
        }
    }


    /**********************************************
     * Getters for various pieces of Weapon Status
     **********************************************/

    virtual int GetStyle(HDWeapon wpn) {
        return style;
    }

    virtual HDMagAmmo GetMagazine(Inventory item) {
        return HDMagAmmo(item);
    }

    virtual HDAmmo GetAmmo(Inventory item) {
        return HDAmmo(item);
    }

    virtual int GetMagRounds(HDWeapon wpn) {
        return 0;
    }

    virtual int GetAmmoCount(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) + ShouldDrawChamberedRound(wpn);
    }

    virtual int GetMagCapacity(HDWeapon wpn, HDMagAmmo mag) {
        return mag ? int(mag.maxPerUnit) : magCapacity;
    }

    virtual int GetFireMode(HDWeapon wpn) {
        return 0;
    }

    virtual int GetWeaponZoom(HDWeapon wpn) {
        return 0;
    }

    virtual Vector2 GetMagazineOffsets() {
        return (-30, 3);
    }

    virtual Vector2 GetAmmoOffsets() {
        return (-30, 3);
    }

    virtual Vector2 GetFireModeOffsets() {
        return (-6, -4);
    }

    virtual Vector2 GetMagazineRoundsOffsets() {
        return (0, 0);
    }

    virtual Vector2 GetAmmoCountOffsets() {
        return (0, -16);
    }

    virtual Vector2 GetChamberedRoundOffsets() {
        return (-3, -5);
    }

    virtual Vector2 GetRangeFinderOffsets() {
        return (-14, -19);
    }

    virtual Vector2 GetWeaponZoomOffsets() {
        return (-14, -16);
    }

    virtual Vector2 GetMagazineScale(HDWeapon wpn, HDMagAmmo mag) {
        return (1.0, 1.0);
    }

    virtual Vector2 GetAmmoScale(HDWeapon wpn, HDAmmo ammo) {
        return (1.0, 1.0);
    }


    /*************************************************************
     * Checks for whether to draw various pieces of Weapon Status
     *************************************************************/

    virtual bool ShouldDrawMagazine(HDWeapon wpn, HDMagAmmo mag) {
        return true;
    }

    virtual bool ShouldDrawFullMagazine(int value, int maxValue) {
        return value >= maxValue;
    }

    virtual bool ShouldDrawEmptyMagazine(int value, int maxValue) {
        return value < 1;
    }

    virtual bool ShouldDrawPartialMagazine(int value, int maxValue) {
        return true;
    }

    virtual bool ShouldDrawAmmo(HDWeapon wpn, HDAmmo ammo) {
        return true;
    }

    virtual bool ShouldDrawFireMode(HDWeapon wpn) {
        return true;
    }

    virtual bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return true;
    }

    virtual bool ShouldDrawAmmoCount(HDWeapon wpn) {
        return true;
    }

    virtual bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return true;
    }

    virtual bool ShouldDrawRangeFinder(HDWeapon wpn) {
        return true;
    }

    virtual bool ShouldDrawWeaponZoom(HDWeapon wpn) {
        return true;
    }


    /****************************************************
     * Drawing Logic for various pieces of Weapon Status
     ****************************************************/

    virtual void DrawWeaponStatus(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        switch (GetStyle(wpn)) {
            case CHAMBER_AND_MAG:
                
                let mag = GetMagazine(sb.hpl.FindInventory(magName));
                
                if (ShouldDrawMagazine(wpn, mag)) {
                    let offs = GetMagazineOffsets();
                    DrawMagazine(sb, wpn, mag, sb.GetNextLoadMag(mag), GetMagCapacity(wpn, mag), posX + (offs.x * scale), posY + (offs.y * scale), scale, hudFont, fontColor, fontScale);
                }

                if (ShouldDrawFireMode(wpn)) {
                    let offs = GetFireModeOffsets();
                    DrawFireMode(sb, wpn, posX + (offs.x * scale), posY + (offs.y * scale), scale);
                }

                if (ShouldDrawMagRounds(wpn, mag)) {
                    let offs = GetMagazineRoundsOffsets();
                    DrawMagazineRounds(sb, wpn, GetMagRounds(wpn), GetMagCapacity(wpn, mag), posX + (offs.x * scale), posY + (offs.y * scale), scale, hudFont, fontColor, fontScale);
                }

                if (ShouldDrawChamberedRound(wpn)) {
                    let offs = GetChamberedRoundOffsets();
                    DrawChamberedRound(sb, wpn, posX + (offs.x * scale), posY + (offs.y * scale), scale);
                }

                break;
            case CHAMBER_MAG_AND_SADDLES:
                break;
            case GL_RANGE_FINDER:

                if (ShouldDrawRangeFinder(wpn)) {
                    let offs = GetRangeFinderOffsets();
                    DrawRangeFinder(sb, wpn, posX + (offs.x * scale), posY + (offs.y * scale), scale, hudFont, fontColor, fontScale);
                }
    
                break;
            case CELL_WEAPON:
                break;
            case BOLT_ACTION:
                break;
            case CUSTOM:
            default:
                break;
        }
    }

    virtual void DrawMagazine(HCStatusBar sb, HDWeapon wpn, HDMagAmmo mag, int value, int maxValue, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        let iconScale = GetMagazineScale(wpn, mag);

        if (ShouldDrawFullMagazine(value, maxValue)) {
            sb.DrawImage(
                magIconFull,
                (posX, posY),
                sb.DI_SCREEN_CENTER_BOTTOM,
                scale: (iconScale.x * scale, iconScale.y * scale)
            );
        } else if (ShouldDrawEmptyMagazine(value, maxValue)) {
            sb.DrawImage(
                magIconEmpty,
                (posX, posY),
                sb.DI_SCREEN_CENTER_BOTTOM,
                alpha: value == 0 ? 1.0 : 0.6,
                scale: (iconScale.x * scale, iconScale.y * scale)
            );
        } else if (ShouldDrawPartialMagazine(value, maxValue)) {
            sb.DrawBar(
                magIconFG,
                magIconBG,
                value,
                maxValue,
                (posX, posY),
                -1,
                sb.SHADER_VERT,
                sb.DI_SCREEN_CENTER_BOTTOM
            );
        }

        sb.DrawString(
            hudFont,
            sb.FormatNumber(sb.hpl.CountInv(mag ? mag.GetClassName() : magName)),
            (posX + (3 * scale), posY - (5 * scale)),
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT,
            fontColor,
            scale: (fontScale * scale, fontScale * scale)
        );
    }

    virtual void DrawAmmo(HCStatusBar sb, HDWeapon wpn, HDAmmo ammo, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        let iconScale = GetAmmoScale(wpn, ammo);

        sb.DrawImage(
            ammoIcon,
            (posX, posY),
            sb.DI_SCREEN_CENTER_BOTTOM,
            scale: (iconScale.x * scale, iconScale.y * scale)
        );

        sb.DrawString(
            hudFont,
            sb.FormatNumber(sb.hpl.CountInv(ammo ? ammo.GetClassName() : ammoName)),
            (posX + (6 * scale), posY - (4 * scale)),
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT,
            fontColor,
            scale: (fontScale * scale, fontScale * scale)
        );
    }

    virtual void DrawFireMode(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale) {
        int input = min(GetFireMode(wpn), 6);
        string result = "";

        for (int i = input; i >= 0; i--) {
            if (input == i) {
                if (fireModes[i] == "blank") break;
				else if(fireModes[i] == "") input--;
                else result = fireModes[i];
            }
        }

        if (result != "") {
            sb.DrawImage(
                result,
                (posX, posY),
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TRANSLATABLE|sb.DI_ITEM_RIGHT,
                scale: (scale, scale)
            );
        }
    }

    virtual void DrawMagazineRounds(HCStatusBar sb, HDWeapon wpn, int value, int maxValue, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        if (!maxValue) return;
        
        double valX = max(((value * 6 / maxValue) << 2), (value > 0));

        sb.DrawRect(
            posX,
            posY,
            max(-24, -valX) * scale,
            -2 * scale
        );

        if (valX > 24) {
            sb.Fill(
                Color(255, 240, 230, 40),
                posX, posY,
                -1,
                -2,
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_RIGHT
            );
        }
    }

    virtual void DrawAmmoCount(HCStatusBar sb, HDWeapon wpn, int value, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        sb.DrawString(
            hudFont,
            sb.FormatNumber(value),
            (posX, posY),
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT,
            Font.CR_RED,
            scale: (fontScale * scale, fontScale * scale)
        );
    }

    virtual void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale) {
        sb.DrawRect(posX, posY, 3 * scale, 1 * scale);
    }

    virtual void DrawRangeFinder(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        let ab = wpn.airburst;

        sb.DrawString(
            hudFont,
            ab ? String.Format("%.2f", ab * 0.01) : "--.--", // TODO: Allow for multiple distance units?  Currently in cm.
            (posX, posY),
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT,
            ab ? Font.CR_WHITE : Font.CR_BLACK,
            scale: (fontScale * scale, fontScale * scale)
        );

        sb.DrawRect(
            posX - 4, posY - 18 + min(16, ab >> 9),
            4 * scale,
            scale
        );

        sb.DrawRect(
            posX - 1, posY - 17,
            scale,
            16 * scale
        );

        sb.DrawRect(
            posX - 3, posY - 17,
            scale,
            16 * scale
        );
    }

    virtual void DrawWeaponZoom(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        sb.DrawString(
            hudFont,
            sb.FormatNumber(GetWeaponZoom(wpn)),
            (posX, posY),
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT,
            Font.CR_DARKGRAY,
            scale: (fontScale * scale, fontScale * scale)
        );
    }
}
