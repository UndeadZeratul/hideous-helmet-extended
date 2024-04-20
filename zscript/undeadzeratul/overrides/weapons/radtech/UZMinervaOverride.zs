class UZMinervaOverride : UZVulcanetteOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'MinervaChaingun';

        magName = 'HD9mMag30';
        magCapacity = 30;
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'HD9mMag30',                                      // name
            30,                                               // capacity
            'CLP3A0', 'CLP3B0', 'CLP3NORM', 'CLP3GREY',       // icons
            (2.0, 2.0),                                       // iconScale
            (-30, 3),                                         // offsets
            (3, -5),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddBatteryCount(
            'HDBattery',                                      // name
            20,                                               // capacity
            'CELLA0', 'CELLB0', 'CELLC0', 'CELLD0',           // icons
            (1.0, 1.0),                                       // iconScale
            (-48, 2),                                         // offsets
            (8, -4),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetMagAmount(int amount) {
        return clamp(amount, 0, magCapacity);
    }

    override int GetAmmoCounter(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagAmount(GetMagRounds(wpn));
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 1;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HD9mMag30': return ammoCounter.type == type;
            case 'HDBattery': return ammoCounter.type == type;
            default:          return false;
        }
    }
}
