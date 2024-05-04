class UZFenrisOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDFenris';

        magName = 'HDBattery';
        magCapacity = 20;

        fireModes[0] = 'STFULAUT';
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
        let charge = wpn.weaponStatus[1];

        if (charge == -1) return -1;

        return int(ceil(charge / (wpn.weaponStatus[0] & 4 ? 4.0 : 3.0)));
    }

    override int GetAmmoCounter(HDWeapon wpn, HDMagAmmo mag) {
        return int((wpn.weaponStatus[1] / (wpn.weaponStatus[0] & 4 ? 80.0 : 60.0)) * 100);
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[3];
    }

    override int GetAmmoCounterFontColor(HDWeapon wpn, HDMagAmmo mag) {
        if (GetBatteryCharge(wpn) > 0) {
            let percent = GetAmmoCounter(wpn, mag);

            if (percent < 25)      return Font.CR_RED;
            else if (percent < 50) return Font.CR_ORANGE;
            else if (percent < 75) return Font.CR_YELLOW;
            else                   return Font.CR_GREEN;
        }

        return Font.CR_DARKGRAY;
    }

    override Vector2 GetFireModeOffsets(HDWeapon wpn) {
        return (1, -9);
    }

    override Vector2 GetAmmoCounterOffsets(HDWeapon wpn) {
        return (2, -6);
    }

    override Vector2 GetBatteryChargeOffsets(HDWeapon wpn) {
        return (2, -4);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type;
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawBatteryCharge(HDWeapon wpn, HDMagAmmo mag) {
        return GetBatteryCharge(wpn) <= 0;
    }

    override bool ShouldDrawAmmoCounter(HDWeapon wpn) {
        return GetBatteryCharge(wpn) > 0;
    }

    override void DrawAmmoCounter(HCStatusBar sb, HDWeapon wpn, int value, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {
        sb.DrawString(
            hudFont,
            value..'%',
            (posX, posY),
            flags,
            fontColor,
            scale: (fontScale * scale, fontScale * scale)
        );
    }
}
