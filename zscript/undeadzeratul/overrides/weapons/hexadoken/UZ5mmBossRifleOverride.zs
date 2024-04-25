class UZ5mmBossRifleOverride : UZBossRifleOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'BossRifleButItsFuckingPink';

        magCapacity = 27;
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'HD5MM_Ammo',                                     // name
            '5MMZA0',                                         // icon
            (2.1, 2.1),                                       // iconScale
            (-38, -4),                                        // offsets
            (3, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override string GetFormattedDropAdjust(float dropAdjust) {
        return String.Format("%.1f", dropAdjust * 0.1);
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HD5MM_Ammo': return ammoCounter.type == type;
            default:           return false;
        }
    }
}
