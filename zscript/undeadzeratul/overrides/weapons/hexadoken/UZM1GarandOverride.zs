class UZM1GarandOverride : BaseWeaponStatusOverride {
    
    private transient CVar _ammoType;

    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDGarand';

        magCapacity = 7;

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STFULAUT';
    }

    override void InitCvars(HCStatusBar sb) {
        super.InitCvars(sb);

        if (!_ammoType) _ammoType = CVar.GetCVar("hd_garand_ammotype", sb.CPlayer);
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'HDGarandClip',                                   // name
            8,                                                // capacity
            'GCLPA0', 'GCLPI0', 'GCLPA0', 'GCLPH0',           // icons
            (1.5, 1.5),                                       // iconScale
            (-30, 3),                                         // offsets
            (3, -5),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
        AddMagCount(
            'HDGarand3006Clip',                               // name
            8,                                                // capacity
            'GCLPA0', 'GCLPI0', 'GCLPA0', 'GCLPH0',           // icons
            (1.5, 1.5),                                       // iconScale
            (-30, 3),                                         // offsets
            (3, -5),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetChamberedRounds(HDWeapon wpn) {
        return wpn.weaponStatus[3];
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 16;
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-3, -5);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {

        switch (ammoCounter.name) {
            case 'HDGarandClip':     return ammoCounter.type == type && (_ammoType && _ammoType.GetInt() > 0);
            case 'HDGarand3006Clip': return ammoCounter.type == type && (_ammoType && _ammoType.GetInt() == 0);
            default:                 return false;
        }
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 1;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn) == 2;
    }
}
