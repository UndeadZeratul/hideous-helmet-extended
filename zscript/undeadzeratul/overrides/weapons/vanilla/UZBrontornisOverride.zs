class UZBrotornisOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'Brontornis';

        AddAmmoCount(
            'BrontornisRound',                                // name
            'BROCA0',                                         // icon
            (0.7, 0.7),                                       // iconScale
            (-32, -4),                                        // offsets
            (3, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.owner.CountInv('BrontornisRound');
    }

    override int GetMagCapacity(HDWeapon wpn, HDMagAmmo mag) {
        return 600 / 11.2; // HDCONST_MAXPOCKETSPACE / ENC_BRONTOSHELL
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-5, -7);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return wpn.weaponStatus[1];
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
