class UZAurochsOverride : UZRevolverOverride {

    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDAurochs';

        AddAmmoCount(
            'HDAurochsAmmo',                                  // name
            '420BA0',                                         // icon
            (2.1, 2.55),                                      // iconScale
            (-31, -4),                                        // offsets
            (3, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddAmmoCount(
            'HD069BoreAmmo',                                  // name
            '42BRA0',                                         // icon
            (2.1, 2.1),                                       // iconScale
            (-48, -4),                                        // offsets
            (4, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override Color GetFullCylinderColor(HDWeapon wpn, int i) {
        switch (GetCylinderRound(wpn, i)) {
            case 1:
            case 2:
                return Color(255, 112, 112, 112);
            case 3:
            case 4:
                return Color(255, 19, 98, 4);
            default:
                return GetEmptyCylinderColor(wpn, i);
        }
    }

    override double GetRevolverCylinderAngle(HDWeapon wpn, int i, int numCylinders) {
        return BaseWeaponStatusOverride.GetRevolverCylinderAngle(wpn, i, numCylinders);
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HDAurochsAmmo': return ammoCounter.type == type;
            case 'HD069BoreAmmo': return ammoCounter.type == type && !!item;
            default:              return false;
        }
    }
}
