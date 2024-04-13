class UZSingleActionRevolverOverride : UZRevolverOverride {

    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDSingleActionRevolver';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'HD45LCAmmo',                                     // name
            'RN45A0',                                         // icon
            (2.1, 2.55),                                      // iconScale
            (-31, -4),                                        // offsets
            (3, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HD45LCAmmo': return ammoCounter.type == type;
            default:           return false;
        }
    }
}
