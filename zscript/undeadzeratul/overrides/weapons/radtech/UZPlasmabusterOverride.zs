class UZPlasmabusterOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'PlasmaBuster';

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
