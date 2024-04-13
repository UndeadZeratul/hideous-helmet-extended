class UZOtis5Override : UZRevolverOverride {

    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDOtisGun';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'HD500SWHeavyAmmo',                               // name
            'SWRNB0',                                         // icon
            (2.1, 2.55),                                      // iconScale
            (-31, -4),                                        // offsets
            (3, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddAmmoCount(
            'HD500SWLightAmmo',                               // name
            'SWRNA0',                                         // icon
            (2.1, 2.1),                                       // iconScale
            (-48, -4),                                        // offsets
            (4, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetNumCylinders(HDWeapon wpn) {
        return 5;
    }

    override double GetRevolverCylinderAngle(HDWeapon wpn, int i, int numCylinders) {
        return BaseWeaponStatusOverride.GetRevolverCylinderAngle(wpn, i, numCylinders);
    }

    override int GetRevolverCylinderRotation(HDWeapon wpn) {
        return -162;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HD500SWHeavyAmmo': return ammoCounter.type == type;
            case 'HD500SWLightAmmo': return ammoCounter.type == type;
            default:                 return false;
        }
    }
}
