class UZPhazerOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'PhazerPistol';

        magName = 'HDMicroCell';
        magCapacity = 10;
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddBatteryCount(
            'HDMicroCell',                                    // name
            10,                                               // capacity
            'MCLLA0', 'MCLLB0', 'MCLLC0', 'MCLLD0',           // icons
            (1.0, 1.0),                                       // iconScale
            (-30, -4),                                        // offsets
            (0, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[5];
    }

    override int GetMagCapacity(HDWeapon wpn, HDMagAmmo mag) {
        return 40 - (GetMagRounds(wpn) == 40 ? 10 : 0);
    }

    override int GetBatteryCharge(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetBatteryCapacity(HDWeapon wpn, HDMagAmmo mag) {
        return mag ? int(mag.maxPerUnit) : 10;
    }

    override Vector2 GetMagazineRoundsOffsets(HDWeapon wpn) {
        return (0, -4);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawBatteryCharge(HDWeapon wpn, HDMagAmmo mag) {
        return true;
    }
}
