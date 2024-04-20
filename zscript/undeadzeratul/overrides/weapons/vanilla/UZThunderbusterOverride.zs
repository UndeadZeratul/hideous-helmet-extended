class UZThunderbusterOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'Thunderbuster';

        magName = 'HDBattery';
        magCapacity = 20;

        fireModes[1] = 'STBURAUT';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddBatteryCount(
            'HDBattery',                                      // name
            20,                                               // capacity
            'CELLA0', 'CELLB0', 'CELLC0', 'CELLD0',           // icons
            (1.0, 1.0),                                       // iconScale
            (-38, 2),                                         // offsets
            (8, -4),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetBatteryCharge(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 1;
    }

    virtual Vector2 GetMaxRangeOffsets(HDWeapon wpn) {
        return (0, -11);
    }

    override Vector2 GetFireModeOffsets(HDWeapon wpn) {
        return (-12, -4);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type;
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 1;
    }

    virtual bool ShouldDrawMaxRange(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return false;
    }

    override bool ShouldDrawBatteryCharge(HDWeapon wpn, HDMagAmmo mag) {
        return true;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn) == 2;
    }

    override void DrawWeaponStatus(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        super.DrawWeaponStatus(sb, wpn, posX, posY, scale, hudFont, fontColor, fontScale);

        if (ShouldDrawMaxRange(wpn)) {
            let offs = GetMaxRangeOffsets(wpn);
            DrawMaxRange(
                sb, wpn,
                GetFireMode(wpn)
                    ? int(2000 / HDCONST_ONEMETRE)
                    : wpn.weaponStatus[4],
                posX + (offs.x * scale),
                posY + (offs.y * scale),
                scale,
                hudFont,
                Font.CR_GRAY,
                fontScale,
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT
            );
        }
    }

    virtual void DrawMaxRange(HCStatusBar sb, HDWeapon wpn, int value, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {
        sb.DrawString(
            hudFont,
            sb.FormatNumber(value),
            (posX, posY),
            flags,
            fontColor,
            scale: (fontScale * scale, fontScale * scale)
        );
    }
}
