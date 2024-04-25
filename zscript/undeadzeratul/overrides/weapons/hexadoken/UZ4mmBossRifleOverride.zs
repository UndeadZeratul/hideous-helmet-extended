class UZ4mmBossRifleOverride : UZBossRifleOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'BossRifleButIts4mm';

        magCapacity = 10;
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'FourMilAmmo',                                    // name
            '4RNDA0',                                         // icon
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

    override Vector2 GetWeaponZoomOffsets(HDWeapon wpn) {
        return (-20, -12);
    }

    override Vector2 GetDropAdjustOffsets(HDWeapon wpn) {
        return (0, -12);
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'FourMilAmmo': return ammoCounter.type == type;
            default:            return false;
        }
    }
}
