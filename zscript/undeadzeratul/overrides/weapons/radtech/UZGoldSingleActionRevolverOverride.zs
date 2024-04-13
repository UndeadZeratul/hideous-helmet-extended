class UZGoldSingleActionRevolverOverride : UZRevolverOverride {

    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDGoldSingleActionRevolver';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'HDGold45LCAmmo',                                 // name
            'GC45A0',                                         // icon
            (2.1, 2.55),                                      // iconScale
            (-31, -4),                                        // offsets
            (3, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HDGold45LCAmmo': return ammoCounter.type == type;
            default:               return false;
        }
    }
}
