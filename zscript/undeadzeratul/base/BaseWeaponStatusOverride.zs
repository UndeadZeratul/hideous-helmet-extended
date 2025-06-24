class WeaponStatusAmmoCounter {
    
    name name;

    bool isMag;

    int magCapacity;
    
    string magIconFull;
    string magIconEmpty;
    string magIconFG;
    string magIconBG;

    string ammoIcon;

    Vector2 iconScale;

    Vector2 offsets;
    Vector2 countOffsets;

    int iconFlags;
    int countFlags;
}

class BaseWeaponStatusOverride : HCItemOverride abstract {

    protected name weaponName;
    protected name magName;

    protected int magCapacity;

    protected Array<WeaponStatusAmmoCounter> ammoCounts;

    protected string fireModes[7];

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
        return (!_enabled || _enabled.GetBool()) && item.GetClassName() == weaponName;
    }

    virtual void InitCvars(HCStatusBar sb) {
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
    }

    override void Tick(HCStatusbar sb) {
        InitCvars(sb);
    }

    override void DrawHUDStuff(HCStatusbar sb, Inventory item, int hdFlags, int gzFlags) {
        InitCvars(sb);
        
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

    virtual HDMagAmmo GetMagazine(Inventory item) {
        return HDMagAmmo(item);
    }

    virtual HDAmmo GetAmmo(Inventory item) {
        return HDAmmo(item);
    }

    virtual int GetMagRounds(HDWeapon wpn) {
        return 0;
    }

    virtual int GetMagCapacity(HDWeapon wpn, HDMagAmmo mag) {
        return mag ? int(mag.maxPerUnit) : magCapacity;
    }

    virtual int GetSideSaddleRounds(HDWeapon wpn) {
        return 0;
    }

    virtual int GetSideSaddleCapacity(HDWeapon wpn) {
        return 0;
    }

    virtual int GetAmmoCounter(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) + ShouldDrawChamberedRound(wpn);
    }

    virtual int GetNumCylinders(HDWeapon wpn) {
        return 0;
    }

    virtual int GetCylinderRadius(HDWeapon wpn) {
        return 1;
    }

    virtual int GetFireMode(HDWeapon wpn) {
        return 0;
    }

    virtual int GetWeaponZoom(HDWeapon wpn) {
        return 0;
    }

    virtual Vector2 GetFireModeOffsets(HDWeapon wpn) {
        return (-6, -4);
    }

    virtual Vector2 GetMagazineRoundsOffsets(HDWeapon wpn) {
        return (0, 0);
    }

    virtual Vector2 GetAmmoCounterOffsets(HDWeapon wpn) {
        return (0, -16);
    }

    virtual Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-3, -5);
    }

    virtual Vector2 GetRevolverCylindersOffsets(HDWeapon wpn) {
        return (-6, -14);
    }

    virtual double GetRevolverCylinderAngle(HDWeapon wpn, int i, int numCylinders) {
        return i * (360.0 / double(numCylinders)) - 150;
    }

    virtual Vector2 GetRevolverCylinderOffsets(HDWeapon wpn, int i, int numCylinders) {
        double cylAngle = GetRevolverCylinderAngle(wpn, i, numCylinders);

        return (cos(cylAngle), sin(cylAngle)) * GetCylinderRadius(wpn);
    }

    virtual Vector2 GetRangeFinderOffsets(HDWeapon wpn) {
        return (-14, -19);
    }

    virtual Vector2 GetWeaponZoomOffsets(HDWeapon wpn) {
        return (-14, -16);
    }

    virtual Vector2 GetSideSaddleOffsets(HDWeapon wpn) {
        return (-14, -16);
    }


    /**********************************************
     * Setters for various pieces of Weapon Status
     **********************************************/

     virtual void AddMagCount(name name, int capacity, name iconFull, name iconEmpty, name iconFG, name iconBG, Vector2 iconScale, Vector2 offsets, Vector2 countOffsets, int iconFlags, int countFlags) {

        let mag = WeaponStatusAmmoCounter(new ('WeaponStatusAmmoCounter'));

        mag.name = name;
        mag.isMag = true;
        mag.magCapacity = capacity;
        mag.magIconFull = iconFull;
        mag.magIconEmpty = iconEmpty;
        mag.magIconFG = iconFG;
        mag.magIconBG = iconBG;
        mag.iconScale = iconScale;
        mag.offsets = offsets;
        mag.countOffsets = countOffsets;
        mag.iconFlags = iconFlags;
        mag.countFlags = countFlags;

        ammoCounts.push(mag);
     }

     virtual void AddAmmoCount(name name, name icon, Vector2 iconScale, Vector2 offsets, Vector2 countOffsets, int iconFlags, int countFlags) {

        let ammo = WeaponStatusAmmoCounter(new ('WeaponStatusAmmoCounter'));

        ammo.name = name;
        ammo.ammoIcon = icon;
        ammo.iconScale = iconScale;
        ammo.offsets = offsets;
        ammo.countOffsets = countOffsets;
        ammo.iconFlags = iconFlags;
        ammo.countFlags = countFlags;

        ammoCounts.push(ammo);
     }


    /*************************************************************
     * Checks for whether to draw various pieces of Weapon Status
     *************************************************************/

    virtual bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return false;
    }

    virtual bool ShouldDrawAmmoCount(HDWeapon wpn, bool isMag, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return !!item;
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

    virtual bool ShouldDrawFireMode(HDWeapon wpn) {
        return false;
    }

    virtual bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return false;
    }

    virtual bool ShouldDrawAmmoCounter(HDWeapon wpn) {
        return false;
    }

    virtual bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return false;
    }

    virtual bool ShouldDrawRevolverCylinders(HDWeapon wpn) {
        return false;
    }

    virtual bool ShouldDrawRangeFinder(HDWeapon wpn) {
        return false;
    }

    virtual bool ShouldDrawWeaponZoom(HDWeapon wpn) {
        return false;
    }

    virtual bool ShouldDrawSideSaddles(HDWeapon wpn) {
        return false;
    }


    /****************************************************
     * Drawing Logic for various pieces of Weapon Status
     ****************************************************/

    virtual void DrawWeaponStatus(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {

        if (ShouldDrawAmmoCounts(wpn)) {
            // let offs = GetAmmoCountOffsets(wpn);
            DrawAmmoCounts(
                sb, wpn,
                ammoCounts,
                posX/*  + (offs.x * scale) */,
                posY/*  + (offs.y * scale) */,
                scale,
                hudFont,
                fontColor,
                fontScale
            );
        }

        let mag  = GetMagazine(sb.hpl.FindInventory(magName));
        // let ammo = GetAmmo(sb.hpl.FindInventory(ammoName));

        if (ShouldDrawAmmoCounter(wpn)) {
            let offs = GetAmmoCounterOffsets(wpn);
            DrawAmmoCounter(
                sb, wpn,
                GetAmmoCounter(wpn, mag),
                posX + (offs.x * scale),
                posY + (offs.y * scale),
                scale,
                hudFont,
                fontColor,
                fontScale,
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT
            );
        }

        if (ShouldDrawFireMode(wpn)) {
            let offs = GetFireModeOffsets(wpn);
            DrawFireMode(
                sb, wpn,
                posX + (offs.x * scale),
                posY + (offs.y * scale),
                scale,
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TRANSLATABLE|sb.DI_ITEM_RIGHT
            );
        }

        if (ShouldDrawMagRounds(wpn, mag)) {
            let offs = GetMagazineRoundsOffsets(wpn);
            DrawMagazineRounds(
                sb, wpn,
                GetMagRounds(wpn),
                GetMagCapacity(wpn, mag),
                Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
                posX + (offs.x * scale),
                posY + (offs.y * scale),
                scale,
                hudFont,
                fontColor,
                fontScale,
                sb.DI_SCREEN_CENTER_BOTTOM
            );
        }

        if (ShouldDrawRevolverCylinders(wpn)) {
            let offs = GetRevolverCylindersOffsets(wpn);
            DrawRevolverCylinders(
                sb, wpn,
                GetNumCylinders(wpn),
                Color(255, 240, 230, 40),
                Color(200, 30,  26,  24),
                posX + (offs.x * scale),
                posY + (offs.y * scale),
                scale,
                SB.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_RIGHT
            );
        }

        if (ShouldDrawChamberedRound(wpn)) {
            let offs = GetChamberedRoundOffsets(wpn);
            DrawChamberedRound(
                sb, wpn,
                Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
                posX + (offs.x * scale),
                posY + (offs.y * scale),
                scale,
                SB.DI_SCREEN_CENTER_BOTTOM
            );
        }

        if (ShouldDrawRangeFinder(wpn)) {
            let offs = GetRangeFinderOffsets(wpn);
            DrawRangeFinder(
                sb, wpn,
                Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
                posX + (offs.x * scale),
                posY + (offs.y * scale),
                scale,
                hudFont,
                fontColor,
                fontScale,
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT
            );
        }

        if (ShouldDrawWeaponZoom(wpn)) {
            let offs = GetWeaponZoomOffsets(wpn);
            DrawWeaponZoom(
                sb, wpn,
                posX + (offs.x * scale),
                posY + (offs.y * scale),
                scale,
                hudFont,
                fontColor,
                fontScale,
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT
            );
        }

        if (ShouldDrawSideSaddles(wpn)) {
            let offs = GetSideSaddleOffsets(wpn);
            DrawSideSaddles(
                sb, wpn,
                Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
                posX + (offs.x * scale),
                posY + (offs.y * scale),
                scale,
                hudFont,
                fontColor,
                fontScale,
                sb.DI_SCREEN_CENTER_BOTTOM
            );
        }
    }

    virtual void DrawAmmoCounts(HCStatusBar sb, HDWeapon wpn, Array<WeaponStatusAmmoCounter> ammoCounts, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        foreach (ammoCount : ammoCounts) {

            let mag  = GetMagazine(sb.hpl.FindInventory(ammoCount.name));
            let ammo = GetAmmo(sb.hpl.FindInventory(ammoCount.name));

            if (ShouldDrawAmmoCount(wpn, true, ammoCount, mag)) {
                DrawMagazine(
                    sb, wpn, mag,
                    ammoCount,
                    sb.GetNextLoadMag(mag),
                    GetMagCapacity(wpn, mag),
                    posX + (ammoCount.offsets.x * scale),
                    posY + (ammoCount.offsets.y * scale),
                    scale,
                    hudFont,
                    fontColor,
                    fontScale
                );
            } else if (ShouldDrawAmmoCount(wpn, false, ammoCount, ammo)) {
                DrawAmmo(
                    sb, wpn, ammo,
                    ammoCount,
                    posX + (ammoCount.offsets.x * scale),
                    posY + (ammoCount.offsets.y * scale),
                    scale,
                    hudFont,
                    fontColor,
                    fontScale
                );
            }
        }
    }

    virtual void DrawMagazine(HCStatusBar sb, HDWeapon wpn, HDMagAmmo mag, WeaponStatusAmmoCounter ammoCounter, int value, int maxValue, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        if (ShouldDrawFullMagazine(value, maxValue)) {
            sb.DrawImage(
                ammoCounter.magIconFull,
                (posX, posY),
                ammoCounter.iconFlags,
                scale: (ammoCounter.iconScale.x * scale, ammoCounter.iconScale.y * scale)
            );
        } else if (ShouldDrawEmptyMagazine(value, maxValue)) {
            sb.DrawImage(
                ammoCounter.magIconEmpty,
                (posX, posY),
                ammoCounter.iconFlags,
                alpha: value == 0 ? 1.0 : 0.6,
                scale: (ammoCounter.iconScale.x * scale, ammoCounter.iconScale.y * scale)
            );
        } else if (ShouldDrawPartialMagazine(value, maxValue)) {
            sb.DrawBar(
                ammoCounter.magIconFG,
                ammoCounter.magIconBG,
                value,
                maxValue,
                (posX, posY),
                -1,
                sb.SHADER_VERT,
                ammoCounter.iconFlags
            );
        }

        sb.DrawString(
            hudFont,
            sb.FormatNumber(sb.hpl.CountInv(mag ? mag.GetClassName() : ammoCounter.name)),
            (posX + (ammoCounter.countOffsets.x * scale), posY + (ammoCounter.countOffsets.y * scale)),
            ammoCounter.countFlags,
            fontColor,
            scale: (fontScale * scale, fontScale * scale)
        );
    }

    virtual void DrawAmmo(HCStatusBar sb, HDWeapon wpn, HDAmmo ammo, WeaponStatusAmmoCounter ammoCounter, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        sb.DrawImage(
            ammoCounter.ammoIcon,
            (posX, posY),
            ammoCounter.iconFlags,
            scale: (ammoCounter.iconScale.x * scale, ammoCounter.iconScale.y * scale)
        );

        sb.DrawString(
            hudFont,
            sb.FormatNumber(sb.hpl.CountInv(ammo ? ammo.GetClassName() : ammoCounter.name)),
            (posX + (ammoCounter.countOffsets.x * scale), posY + (ammoCounter.countOffsets.y * scale)),
            ammoCounter.countFlags,
            fontColor,
            scale: (fontScale * scale, fontScale * scale)
        );
    }

    virtual void DrawFireMode(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, int flags) {
        int input = min(GetFireMode(wpn), 6);
        string result = "";

        for (int i = input; i >= 0; i--) {
            if (input == i) {
                if (fireModes[i] == "blank") break;
				else if (fireModes[i] == "") input--;
                else result = fireModes[i];
            }
        }

        if (result != "") {
            sb.DrawImage(
                result,
                (posX, posY),
                flags,
                scale: (scale, scale)
            );
        }
    }

    virtual void DrawMagazineRounds(HCStatusBar sb, HDWeapon wpn, int value, int maxValue, Color color, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {
        if (!maxValue) return;
        
        double valX = max(((value * 6 / maxValue) << 2), (value > 0));

        sb.Fill(
            color,
            posX, posY,
            max(-24, -valX) * scale, -2 * scale,
            flags
        );

        if (valX > 24) {
            sb.Fill(
                Color(255, 240, 230, 40),
                posX, posY,
                -1, -2,
                flags
            );
        }
    }

    virtual void DrawAmmoCounter(HCStatusBar sb, HDWeapon wpn, int value, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {
        sb.DrawString(
            hudFont,
            sb.FormatNumber(value),
            (posX, posY),
            flags,
            Font.CR_RED,
            scale: (fontScale * scale, fontScale * scale)
        );
    }

    virtual void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        sb.Fill(
            color,
            posX, posY,
            3 * scale, 1 * scale,
            flags
        );
    }

    virtual void DrawRevolverCylinders(HCStatusBar sb, HDWeapon wpn, int numCylinders, Color colorFull, Color colorEmpty, int posX, int posY, float scale, int flags) {
        for (int i = 1; i <= numCylinders; i++) {
            let cylOffs = GetRevolverCylinderOffsets(wpn, i, numCylinders);
            DrawRevolverCylinder(
                sb, wpn,
                wpn.weaponStatus[i] > 0 ? colorFull : colorEmpty,
                posX + (cylOffs.x * scale),
                posY + (cylOffs.y * scale),
                scale,
                flags
            );
        }
    }

    virtual void DrawRevolverCylinder(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        sb.fill(
            color,
            posX,
            posY,
            3 * scale, 3 * scale,
            flags
        );
    }

    virtual void DrawRangeFinder(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {
        let ab = wpn.airburst;

        sb.DrawString(
            hudFont,
            ab ? String.Format("%.2f", ab * 0.01) : "--.--", // TODO: Allow for multiple distance units?  Currently in cm.
            (posX, posY),
            flags,
            ab ? Font.CR_WHITE : Font.CR_BLACK,
            scale: (fontScale * scale, fontScale * scale)
        );

        sb.Fill(
            color,
            posX - (4 * scale), posY + ((-18 + min(16, ab >> 9)) * scale),
            4 * scale, scale,
            flags
        );

        sb.Fill(
            color,
            posX - scale, posY - (17 * scale),
            scale, 16 * scale,
            flags
        );

        sb.Fill(
            color,
            posX - (3 * scale), posY - (17 * scale),
            scale, 16 * scale,
            flags
        );
    }

    virtual void DrawWeaponZoom(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {
        sb.DrawString(
            hudFont,
            sb.FormatNumber(GetWeaponZoom(wpn)),
            (posX, posY),
            flags,
            Font.CR_DARKGRAY,
            scale: (fontScale * scale, fontScale * scale)
        );
    }

    virtual void DrawSideSaddles(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {
        for (int i = GetSideSaddleRounds(wpn); i > 0; i--) {
            sb.Fill(
                color,
                posX - (i * 2 * scale), posY,
                scale, 3 * scale,
                flags
            );
        }
    }

    virtual void DrawHorzVectorShell(HCStatusBar sb, HDWeapon wpn, int style, Color color, int posX, int posY, float scale, int flags) {

        // Empty Casing
        sb.Fill(
            color,
            posX, posY,
            2 * scale, 3 * scale,
            flags
        );

        switch (style) {
            case 0:

                // Vanilla-style Shell
                sb.Fill(
                    color,
                    posX - (6 * scale), posY,
                    5 * scale, 3 * scale,
                    flags
                );
                break;
            case 1:

                // Peppergrinder-style Shell
				sb.Fill(
                    color,
                    posX - (6 * scale), posY,
                    scale, scale,
                    flags
                );
                sb.Fill(
                    color,
                    posX - (4 * scale), posY,
                    scale, scale,
                    flags
                );
                sb.Fill(
                    color,
                    posX - (2 * scale), posY,
                    scale, scale,
                    flags
                );
				
                sb.Fill(
                    color,
                    posX - (5 * scale), posY + scale,
                    scale, scale,
                    flags
                );
                sb.Fill(
                    color,
                    posX - (3 * scale), posY + scale,
                    scale, scale,
                    flags
                );
				
                sb.Fill(
                    color,
                    posX - (6 * scale), posY + (2 * scale),
                    scale, scale,
                    flags
                );
                sb.Fill(
                    color,
                    posX - (4 * scale), posY + (2 * scale),
                    scale, scale,
                    flags
                );
                sb.Fill(
                    color,
                    posX - (2 * scale), posY + (2 * scale),
                    scale, scale,
                    flags
                );
                break;
            case 2:

                // Peppergrinder-style Slug
				sb.Fill(
                    color,
                    posX - (5 * scale), posY,
                    4 * scale, 3 * scale,
                    flags
                );
				sb.Fill(
                    color,
                    posX - (6 * scale), posY + (1 * scale),
                    scale, scale,
                    flags
                );
                break;
        }
    }

    virtual void DrawVertVectorShell(HCStatusBar sb, HDWeapon wpn, int style, Color color, int posX, int posY, float scale, int flags) {

        // Empty Casing
        sb.Fill(
            color,
            posX, posY,
            3 * scale, 2 * scale,
            flags
        );

        switch (style) {
            case 0:

                // Vanilla-style Shell
                sb.Fill(
                    color,
                    posX, posY - (6 * scale),
                    3 * scale, 5 * scale,
                    flags
                );
                break;
            case 1:

                // Peppergrinder-style Shell
				sb.Fill(
                    color,
                    posX, posY - (6 * scale),
                    scale, scale,
                    flags
                );
                sb.Fill(
                    color,
                    posX, posY - (4 * scale),
                    scale, scale,
                    flags
                );
                sb.Fill(
                    color,
                    posX, posY - (2 * scale),
                    scale, scale,
                    flags
                );
				
                sb.Fill(
                    color,
                    posX + scale, posY - (5 * scale),
                    scale, scale,
                    flags
                );
                sb.Fill(
                    color,
                    posX + scale, posY - (3 * scale),
                    scale, scale,
                    flags
                );
				
                sb.Fill(
                    color,
                    posX + (2 * scale), posY - (6 * scale),
                    scale, scale,
                    flags
                );
                sb.Fill(
                    color,
                    posX + (2 * scale), posY - (4 * scale),
                    scale, scale,
                    flags
                );
                sb.Fill(
                    color,
                    posX + (2 * scale), posY - (2 * scale),
                    scale, scale,
                    flags
                );
                break;
            case 2:

                // Peppergrinder-style Slug
				sb.Fill(
                    color,
                    posX, posY - (5 * scale),
                    3 * scale, 4 * scale,
                    flags
                );
				sb.Fill(
                    color,
                    posX + (1 * scale), posY - (6 * scale),
                    scale, scale,
                    flags
                );
                break;
        }
    }
}
