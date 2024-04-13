class UZBlooperOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'Blooper';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'HDRocketAmmo',                                   // name
            'ROQPA0',                                         // icon
            (0.6, 0.6),                                       // iconScale
            (-36, 2),                                         // offsets
            (7, -4),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetChamberedRounds(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 1;
    }

    override Vector2 GetRangeFinderSize() {
        return (6, 32);
    }

    override int GetRangeFinderScale() {
        return 8;
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-5, -7);
    }

    override Vector2 GetRangeFinderOffsets(HDWeapon wpn) {
        return (-6, -3);
    }

    override Vector2 GetRangeFinderTextOffsets(HDWeapon wpn) {
        return (-6, -6);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn);
    }

    override bool ShouldDrawRangeFinder(HDWeapon wpn) {
        return true;
    }

    override void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        sb.Fill(
            color,
            posX, posY,
            5 * scale, 3 * scale,
            flags
        );
    }
}
