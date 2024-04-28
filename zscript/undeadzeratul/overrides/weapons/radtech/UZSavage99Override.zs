class UZSavage99Override : UZBossRifleOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'Savage99SniperRifle';

        magCapacity = 6;
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'Savage300Ammo',                                  // name
            'SVG6A0',                                         // icon
            (1.2, 1.2),                                       // iconScale
            (-40, 2),                                         // offsets
            (4, -4),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetAmmoCounter(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn);
    }

    override int GetAmmoCounterFontColor(HDWeapon wpn, HDMagAmmo mag) {
        return Font.CR_GOLD;
    }

    override Vector2 GetAmmoCounterOffsets(HDWeapon wpn) {
        return (-28, -6);
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type;
    }

    override bool ShouldDrawAmmoCounter(HDWeapon wpn) {
        return true;
    }
}
