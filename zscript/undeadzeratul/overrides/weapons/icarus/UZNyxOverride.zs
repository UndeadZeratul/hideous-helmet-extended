class UZNyxOverride : UZPistolOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDNyx';

        magName = 'HDNyxMag';
        magCapacity = 12;

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STBURAUT';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'HDNyxMag',                                       // name
            12,                                               // capacity
            'NYXMA0', 'NYXMB0', 'NYXMNORM', 'NYXMGREY',       // icons
            (1.0, 1.0),                                       // iconScale
            (-30, 3),                                         // offsets
            (3, -5),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetChamberedRounds(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[2];
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[3];
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return true;
    }
}
