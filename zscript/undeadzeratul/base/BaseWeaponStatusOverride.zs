class WeaponStatusAmmoCounter {
    
    name name;

    int type;

    int magCapacity;

    Array<string> icons;

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

    private transient CVar _mag_barDirection;
    private transient CVar _mag_precise;
    private transient CVar _shellStyle;
    
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

        AddAmmoCounts(sb);
    }

    override bool CheckItem(Inventory item) {
        return (!_enabled || _enabled.GetBool()) && item.GetClassName() == weaponName;
    }

    virtual void InitCvars(HCStatusBar sb) {
        if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

        if (!_hh_hidefiremode) _hh_hidefiremode = CVar.GetCVar("hh_hidefiremode", sb.CPlayer);

        if (!_mag_barDirection) _mag_barDirection = CVar.GetCVar("uz_hhx_weaponStatus_mag_barDirection", sb.CPlayer);
        if (!_mag_precise) _mag_precise           = CVar.GetCVar("uz_hhx_weaponStatus_mag_precise", sb.CPlayer);
        if (!_shellStyle) _shellStyle             = CVar.GetCVar("uz_hhx_weaponStatus_shellStyle", sb.CPlayer);

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
        bool hhelmetShowStatus = _HHFunc && _HHFunc.GetIntUI("CheckWeaponStuff", objectArg: sb);
        int  hudLevel  = hasHelmet ? _hlm_hudLevel.GetInt() : _nhm_hudLevel.GetInt();
        
        if (
            (hasHelmet || !_hlm_required.GetBool())
            && !HDSpectator(sb.hpl)
            && sb.HUDLevel >= hudLevel
            && hhelmetShowStatus
        ) {

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

    virtual HDAmmo GetAmmo(Inventory item) {
        return HDAmmo(item);
    }

    virtual HDMagAmmo GetMagazine(Inventory item) {
        return HDMagAmmo(item);
    }

    virtual HDBattery GetBattery(Inventory item) {
        return HDBattery(item);
    }

    virtual int GetChamberedRounds(HDWeapon wpn) {
        return 0;
    }

    virtual int GetMagRounds(HDWeapon wpn) {
        return 0;
    }

    virtual int GetBatteryCharge(HDWeapon wpn) {
        return 0;
    }

    virtual int GetMagAmount(int amount) {
        return amount;
    }

    virtual int GetMagCapacity(HDWeapon wpn, HDMagAmmo mag) {
        return mag ? int(mag.maxPerUnit) : magCapacity;
    }

    virtual bool GetMagRoundsPrecision(HDWeapon wpn) {
        return false;
    }

    virtual int GetBatteryCapacity(HDWeapon wpn, HDMagAmmo mag) {
        return mag ? int(mag.maxPerUnit) : 20;
    }

    virtual int GetSideSaddleRounds(HDWeapon wpn) {
        return 0;
    }

    virtual int GetSideSaddleCapacity(HDWeapon wpn) {
        return 0;
    }

    virtual int GetAmmoCounter(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) + GetChamberedRounds(wpn);
    }

    virtual int GetNumCylinders(HDWeapon wpn) {
        return 0;
    }

    virtual Color GetFullCylinderColor(HDWeapon wpn, int i) {
        return Color(255, 240, 230, 40);
    }

    virtual Color GetEmptyCylinderColor(HDWeapon wpn, int i) {
        return Color(200, 30,  26,  24);
    }

    virtual int GetCylinderRound(HDWeapon wpn, int i) {
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

    virtual int GetShellStyle(HDWeapon wpn, int state) {
        let cvar = _shellStyle.GetInt();

        // Depending on the CVAR value, return the appropriate style
        // Possible State Values include:
        // -1 = Empty Casing
        // 0 = Simple Shell 
        // 1 = Fancy Shell
        // 2 = Fancy Slug
        switch (cvar) {
            // Automatic
            case 0: return state;
            // Force Vanilla
            case 1: return GetVanillaShellStyle(wpn, state);
            // Force Fancy (1 = Shell, 2 = Slug)
            case 2: return GetFancyShellStyle(wpn, state);
        }

        // Invalid CVAR value, fallback to empty casing
        return -1;
    }

    virtual int GetVanillaShellStyle(HDweapon wpn, int state) {
        return state > -1 ? 0 : -1;
    }

    virtual int GetFancyShellStyle(HDWeapon wpn, int state) {
        return state > -1 ? max(1, min(2, state)) : -1;
    }

    virtual Vector2 GetRangeFinderSize() {
        return (4, 16);
    }

    virtual int GetRangeFinderScale() {
        return 9;
    }

    virtual Vector2 GetFireModeOffsets(HDWeapon wpn) {
        return (-6, -4);
    }

    virtual Vector2 GetMagazineRoundsOffsets(HDWeapon wpn) {
        return (0, 0);
    }

    virtual Vector2 GetBatteryChargeOffsets(HDWeapon wpn) {
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
        return i * (360.0 / double(numCylinders)) + GetRevolverCylinderRotation(wpn);
    }

    virtual int GetRevolverCylinderRotation(HDWeapon wpn) {
        return -150;
    }

    virtual Vector2 GetRevolverCylinderOffsets(HDWeapon wpn, int i, int numCylinders) {
        double cylAngle = GetRevolverCylinderAngle(wpn, i, numCylinders);

        return (cos(cylAngle), sin(cylAngle));
    }

    virtual Vector2 GetRangeFinderOffsets(HDWeapon wpn) {
        return (-14, -19);
    }

    virtual Vector2 GetRangeFinderTextOffsets(HDWeapon wpn) {
        return (0, 0);
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

    virtual void AddAmmoCounts(HCStatusBar sb) {
        // no-op, add ammo counts in child classes.
    }

    virtual void AddAmmoCount(name name, name icon, Vector2 iconScale, Vector2 offsets, Vector2 countOffsets, int iconFlags, int countFlags) {

        let ammo = WeaponStatusAmmoCounter(new ('WeaponStatusAmmoCounter'));

        ammo.name = name;
        ammo.type = 0;
        ammo.icons.push(icon);
        ammo.iconScale = iconScale;
        ammo.offsets = offsets;
        ammo.countOffsets = countOffsets;
        ammo.iconFlags = iconFlags;
        ammo.countFlags = countFlags;

        ammoCounts.push(ammo);
    }

    virtual void AddMagCount(name name, int capacity, name iconFull, name iconEmpty, name iconFG, name iconBG, Vector2 iconScale, Vector2 offsets, Vector2 countOffsets, int iconFlags, int countFlags) {

        let mag = WeaponStatusAmmoCounter(new ('WeaponStatusAmmoCounter'));

        mag.name = name;
        mag.type = 1;
        mag.magCapacity = capacity;
        mag.icons.push(iconFull);
        mag.icons.push(iconEmpty);
        mag.icons.push(iconFG);
        mag.icons.push(iconBG);
        mag.iconScale = iconScale;
        mag.offsets = offsets;
        mag.countOffsets = countOffsets;
        mag.iconFlags = iconFlags;
        mag.countFlags = countFlags;

        ammoCounts.push(mag);
    }

    virtual void AddBatteryCount(name name, int capacity, name iconFull, name iconHigh, name iconLow, name iconEmpty, Vector2 iconScale, Vector2 offsets, Vector2 countOffsets, int iconFlags, int countFlags) {

        let bat = WeaponStatusAmmoCounter(new ('WeaponStatusAmmoCounter'));

        bat.name = name;
        bat.type = 2;
        bat.magCapacity = capacity;
        bat.icons.push(iconFull);
        bat.icons.push(iconHigh);
        bat.icons.push(iconLow);
        bat.icons.push(iconEmpty);
        bat.iconScale = iconScale;
        bat.offsets = offsets;
        bat.countOffsets = countOffsets;
        bat.iconFlags = iconFlags;
        bat.countFlags = countFlags;

        ammoCounts.push(bat);
    }


    /*************************************************************
     * Checks for whether to draw various pieces of Weapon Status
     *************************************************************/

    virtual bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return false;
    }

    virtual bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type && !!item;
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

    virtual bool ShouldDrawMagRoundsPrecise(HDWeapon wpn, bool state) {
        // Force Mag Rounds Precision via CVar
        switch (_mag_precise.GetInt()) {
            case 0:
                return false;
            case 1:
                return true;
            default:
                return state;
        }
    }

    virtual bool ShouldDrawBatteryCharge(HDWeapon wpn, HDMagAmmo mag) {
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

    virtual bool ShouldDrawRangeFinderBar(HDWeapon wpn) {
        return true;
    }

    virtual bool ShouldDrawRangeFinderText(HDWeapon wpn) {
        return true;
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

        if (sb.HUDLevel == 1 && ShouldDrawAmmoCounts(wpn)) {
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
                ShouldDrawMagRoundsPrecise(wpn, GetMagRoundsPrecision(wpn)),
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

        if (ShouldDrawBatteryCharge(wpn, mag)) {
            let offs = GetBatteryChargeOffsets(wpn);
            DrawBatteryCharge(
                sb, wpn,
                GetBatteryCharge(wpn),
                GetBatteryCapacity(wpn, mag),
                ShouldDrawMagRoundsPrecise(wpn, GetMagRoundsPrecision(wpn)),
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
                posX + (offs.x * scale),
                posY + (offs.y * scale),
                scale,
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_RIGHT
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
                sb.DI_SCREEN_CENTER_BOTTOM
            );
        }

        if (ShouldDrawRangeFinder(wpn)) {
            let offs = GetRangeFinderOffsets(wpn);
            let textOffs = GetRangeFinderTextOffsets(wpn);
            DrawRangeFinder(
                sb, wpn,
                GetRangeFinderSize(),
                GetRangeFinderScale(),
                Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
                posX + (offs.x * scale),
                posY + (offs.y * scale),
                scale,
                textOffs.x,
                textOffs.y,
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
            let bat  = GetBattery(sb.hpl.FindInventory(ammoCount.name));
            let ammo = GetAmmo(sb.hpl.FindInventory(ammoCount.name));

            if (ShouldDrawAmmoCount(wpn, 0, ammoCount, ammo)) {
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
            } else if (ShouldDrawAmmoCount(wpn, 1, ammoCount, mag)) {
                DrawMagazine(
                    sb, wpn, mag,
                    ammoCount,
                    GetMagAmount(sb.GetNextLoadMag(mag)),
                    GetMagCapacity(wpn, mag),
                    posX + (ammoCount.offsets.x * scale),
                    posY + (ammoCount.offsets.y * scale),
                    scale,
                    hudFont,
                    fontColor,
                    fontScale
                );
            } else if (ShouldDrawAmmoCount(wpn, 2, ammoCount, bat)) {
                DrawBattery(
                    sb, wpn, bat,
                    ammoCount,
                    GetMagAmount(sb.GetNextLoadMag(bat)),
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

    virtual void DrawBattery(HCStatusBar sb, HDWeapon wpn, HDMagAmmo mag, WeaponStatusAmmoCounter ammoCounter, int value, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        string batIcon;
        
        if (mag && mag.mags.size() > 0) {

            // If "battery" is a child class of HDBattery, render its charge mode
            let bat = GetBattery(mag);
            if (bat && bat.chargemode) {
                if (bat.chargemode == HDBattery.BATT_CHARGEMAX) {
                    sb.DrawImage(
                        'CELPA0',
                        (posX + (2 * scale), posy + (6 * scale)),
                        flags: sb.DI_SCREEN_CENTER_BOTTOM,
                        scale: (0.3 * scale, 0.3 * scale)
                    );
                } else if (bat.chargemode == HDBattery.BATT_CHARGESELECTED) {
                    sb.DrawImage(
                        'CELPA0',
                        (posX, posY + (4 * scale)),
                        flags: sb.DI_SCREEN_CENTER_BOTTOM,
                        scale: (0.3 * scale, 0.3 * scale)
                    );
                }
            }

            if (value > ammoCounter.magCapacity * 0.6) {
                batIcon = ammoCounter.icons[0];
            } else if (value > ammoCounter.magCapacity * 0.3) {
                batIcon = ammoCounter.icons[1];
            } else if (value > 0) {
                batIcon = ammoCounter.icons[2];
            } else {
                batIcon = ammoCounter.icons[3];
            }
        } else {
            batIcon = ammoCounter.icons[3];
        }

        sb.DrawImage(
            batIcon,
            (posX, posY),
            flags: sb.DI_SCREEN_CENTER_BOTTOM,
            alpha: mag ? 1.0 : 0.3
        );

        sb.DrawString(
            hudFont,
            sb.FormatNumber(sb.hpl.CountInv(mag ? mag.GetClassName() : ammoCounter.name)),
            (posX + (ammoCounter.countOffsets.x * scale), posY + (ammoCounter.countOffsets.y * scale)),
            ammoCounter.countFlags,
            fontColor,
            scale: (fontScale * scale, fontScale * scale)
        );
    }

    virtual void DrawMagazine(HCStatusBar sb, HDWeapon wpn, HDMagAmmo mag, WeaponStatusAmmoCounter ammoCounter, int value, int maxValue, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        if (ShouldDrawFullMagazine(value, maxValue)) {
            sb.DrawImage(
                ammoCounter.icons[0],
                (posX, posY),
                ammoCounter.iconFlags,
                scale: (ammoCounter.iconScale.x * scale, ammoCounter.iconScale.y * scale)
            );
        } else if (ShouldDrawEmptyMagazine(value, maxValue)) {
            sb.DrawImage(
                ammoCounter.icons[1],
                (posX, posY),
                ammoCounter.iconFlags,
                alpha: value == 0 ? 1.0 : 0.6,
                scale: (ammoCounter.iconScale.x * scale, ammoCounter.iconScale.y * scale)
            );
        } else if (ShouldDrawPartialMagazine(value, maxValue)) {
            sb.DrawBar(
                ammoCounter.icons[2],
                ammoCounter.icons[3],
                value,
                maxValue,
                (posX, posY),
                -1,
                _mag_barDirection.GetInt(),
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
        let amount = sb.hpl.CountInv(ammo ? ammo.GetClassName() : ammoCounter.name);

        sb.DrawImage(
            ammoCounter.icons[0],
            (posX, posY),
            ammoCounter.iconFlags,
            alpha: amount ? 1.0 : 0.6,
            scale: (ammoCounter.iconScale.x * scale, ammoCounter.iconScale.y * scale)
        );

        sb.DrawString(
            hudFont,
            sb.FormatNumber(amount),
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

    virtual void DrawMagazineRounds(HCStatusBar sb, HDWeapon wpn, int value, int maxValue, bool precise, Color color, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {
        if (!maxValue) return;
        
        double valX = !precise
            ? max(((value * 6 / maxValue) << 2), (value > 0))
            : (value * 24 / maxValue);

        sb.Fill(
            color,
            posX, posY,
            max(-24, -valX) * scale, -2 * scale,
            flags
        );

        if (valX > 24) {
            sb.Fill(
                Color(255, 240, 230, 40),
                posX - 24, posY,
                -1, -2,
                flags
            );
        }
    }

    virtual void DrawBatteryCharge(HCStatusBar sb, HDWeapon wpn, int value, int maxValue, bool precise, Color color, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {
        if (value > 0) {
            DrawMagazineRounds(sb, wpn, value, maxValue, precise, color, posX, posY, scale, hudFont, fontColor, fontScale, flags);
        } else {
            sb.DrawString(
                sb.mAmountFont,
                "00000",
                (posX, posY - scale),
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TRANSLATABLE|sb.DI_TEXT_ALIGN_RIGHT,
                Font.CR_DARKGRAY,
                scale: (scale, scale)
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

    virtual void DrawRevolverCylinders(HCStatusBar sb, HDWeapon wpn, int numCylinders, int posX, int posY, float scale, int flags) {
        let radius = GetCylinderRadius(wpn);

        for (int i = 1; i <= numCylinders; i++) {
            let cylOffs = GetRevolverCylinderOffsets(wpn, i, numCylinders) * radius;

            DrawRevolverCylinder(
                sb, wpn,
                GetCylinderRound(wpn, i)
                    ? GetFullCylinderColor(wpn, i)
                    : GetEmptyCylinderColor(wpn, i),
                posX + cylOffs.x < 0 ? floor(cylOffs.x) : ceil(cylOffs.x),
                posY + cylOffs.y < 0 ? floor(cylOffs.y) : ceil(cylOffs.y),
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

    virtual void DrawRangeFinder(HCStatusBar sb, HDWeapon wpn, Vector2 barSize, int barScale, Color color, int posX, int posY, float scale, int textPosX, int textPosY, HUDFont hudFont, int fontColor, float fontScale, int flags) {
        let ab = wpn.airburst;

        if (ShouldDrawRangeFinderText(wpn)) {
            sb.DrawString(
                ab ? hudFont : sb.mAmountFont,
                ab ? String.Format("%.2f", ab * 0.01) : "--.--", // TODO: Allow for multiple distance units?  Currently in cm.
                (posX + (textPosX * scale), posY + (textPosY * scale)),
                flags,
                ab ? Font.CR_WHITE : Font.CR_BLACK,
                scale: ab ? (fontScale * scale, fontScale * scale) : (scale, scale)
            );
        }

        if (ShouldDrawRangeFinderBar(wpn)) {
            sb.Fill(
                color,
                posX - (barSize.x * scale), posY + ((-(barSize.y + 2) + min(barSize.y, ab >> barScale)) * scale),
                barSize.x * scale, scale,
                flags
            );

            sb.Fill(
                color,
                posX - scale, posY - ((barSize.y + 1) * scale),
                scale, barSize.y * scale,
                flags
            );

            sb.Fill(
                color,
                posX - (3 * scale), posY - ((barSize.y + 1) * scale),
                scale, barSize.y * scale,
                flags
            );
        }
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

    virtual void DrawHorzVectorShell(HCStatusBar sb, HDWeapon wpn, int style, bool flipped, Color color, int posX, int posY, float scale, int flags) {

        // Empty Casing
        sb.Fill(
            color,
            posX - (9 * scale * flipped), posY,
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
                    posX - ((5 + flipped) * scale), posY,
                    4 * scale, 3 * scale,
                    flags
                );
                sb.Fill(
                    color,
                    posX - ((6 - (4 * flipped)) * scale), posY + (1 * scale),
                    scale, scale,
                    flags
                );
                break;
        }
    }

    virtual void DrawVertVectorShell(HCStatusBar sb, HDWeapon wpn, int style, bool flipped, Color color, int posX, int posY, float scale, int flags) {

        // Empty Casing
        sb.Fill(
            color,
            posX, posY - (9 * scale * flipped),
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
                    posX, posY - ((5 + flipped) * scale),
                    3 * scale, 4 * scale,
                    flags
                );
                sb.Fill(
                    color,
                    posX + (1 * scale), posY - ((6 - (4 * flipped)) * scale),
                    scale, scale,
                    flags
                );
                break;
        }
    }
}
