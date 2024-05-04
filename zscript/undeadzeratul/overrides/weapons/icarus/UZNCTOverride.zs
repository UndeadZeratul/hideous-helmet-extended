class UZNCTOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDNCT';

        magName = 'HDBattery';
        magCapacity = 20;
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

    override int GetAmmoCounter(HDWeapon wpn, HDMagAmmo mag) {
        return GetBatteryCharge(wpn);
    }

    override int GetAmmoCounterFontColor(HDWeapon wpn, HDMagAmmo mag) {
        if (GetBatteryCharge(wpn) > 0) {
            return GetAmmoCounter(wpn, mag) > 19
                ? Font.CR_GREEN
                : Font.CR_RED;
        }

        return Font.CR_DARKGRAY;
    }

    override Vector2 GetAmmoCounterOffsets(HDWeapon wpn) {
        return (2, -6);
    }

    override Vector2 GetBatteryChargeOffsets(HDWeapon wpn) {
        return (0, -3);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type;
    }

    override bool ShouldDrawBatteryCharge(HDWeapon wpn, HDMagAmmo mag) {
        return GetBatteryCharge(wpn) == 0;
    }

    override bool ShouldDrawAmmoCounter(HDWeapon wpn) {
        return GetBatteryCharge(wpn) > 0;
    }

    override void DrawAmmoCounter(HCStatusBar sb, HDWeapon wpn, int value, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {
        sb.DrawString(
            hudFont,
            value > 19 ? "READY" : "NOT READY",
            (posX, posY),
            flags,
            fontColor,
            scale: (fontScale * scale, fontScale * scale)
        );
    }
}
