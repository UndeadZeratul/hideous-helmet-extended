class UZ50omgBossRifleOverride : UZBossRifleOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'BogRifle';

        magCapacity = 5;
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'HDOmgClip',                                      // name
            5,                                                // capacity
            'OCLPA0', 'OCLPF0', 'OCLPA0', 'OCLPE0',           // icons
            (1.25, 1.6),                                      // iconScale
            (-34, 3),                                         // offsets
            (7, -5),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddAmmoCount(
            'HD50OMGAmmo',                                    // name
            'OG10A0',                                         // icon
            (1.2, 1.2),                                       // iconScale
            (-46, 2),                                         // offsets
            (6, -4),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override string GetFormattedDropAdjust(float dropAdjust) {
        return String.Format("%.1f", dropAdjust * 0.1);
    }

    override Vector2 GetWeaponZoomOffsets(HDWeapon wpn) {
        return (-20, -12);
    }

    override Vector2 GetDropAdjustOffsets(HDWeapon wpn) {
        return (0, -12);
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HDOmgClip':   return ammoCounter.type == type;
            case 'HD50OMGAmmo': return ammoCounter.type == type;
            default:            return false;
        }
    }
}
