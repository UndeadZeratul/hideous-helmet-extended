class UZ9mmBossRifleOverride : UZBossRifleOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'BossRifleButIts4mm';

        magCapacity = 10;
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        string nineClip = "HD9mClip";
        if ((class<HDPickup>)(nineClip)) {
            AddMagCount(
                'HD9mClip',                                       // name
                50,                                               // capacity
                '9CLPA0', '9CLPF0', '9CLPA0', '9CLPE0',           // icons
                (2.1, 2.1),                                       // iconScale
                (-38, -4),                                        // offsets
                (3, 2),                                           // countOffsets
                sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
            );
        } else {
            AddAmmoCount(
                'NineMilAmmo',                                    // name
                'PRNDA0',                                         // icon
                (2.1, 2.1),                                       // iconScale
                (-38, -4),                                        // offsets
                (3, 2),                                           // countOffsets
                sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
            );
        }
    }

    override string GetFormattedDropAdjust(float dropAdjust) {
        return String.Format("%.1f", dropAdjust * 0.1);
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HD9mClip':    return ammoCounter.type == type;
            case 'NineMilAmmo': return ammoCounter.type == type;
            default:            return false;
        }
    }
}
