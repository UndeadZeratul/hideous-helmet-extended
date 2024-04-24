class UZFragCannonOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'FragCannon';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'HDFragGrenadeAmmo',                              // name
            'FRAGA0',                                         // icon
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

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.owner.CountInv('HDFragGrenadeAmmo');
    }

    override int GetMagCapacity(HDWeapon wpn, HDMagAmmo mag) {
        return 600 / 25.6; // HDCONST_MAXPOCKETSPACE / ENC_FRAG
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
        return GetChamberedRounds(wpn);
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
