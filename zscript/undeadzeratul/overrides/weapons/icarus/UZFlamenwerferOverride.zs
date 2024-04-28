class UZFlamenwerferOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDFlamethrower';

        magName = 'HDGasTank';
        magCapacity = 100;
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'HDGasTank',                                      // name
            100,                                              // capacity
            'AGASA0', 'AGASB0', 'AGASA0', 'AGASB0',           // icons
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

    override int GetBatteryCapacity(HDWeapon wpn, HDMagAmmo mag) {
        return 100;
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 1;
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type;
    }

    override bool ShouldDrawBatteryCharge(HDWeapon wpn, HDMagAmmo mag) {
        return true;
    }
}
