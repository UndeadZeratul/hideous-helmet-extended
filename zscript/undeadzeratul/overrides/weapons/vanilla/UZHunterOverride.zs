class UZHunterOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'Hunter';

        fireModes[0] = 'blank';
        fireModes[1] = 'STSEMAUT';
        fireModes[2] = 'STFULAUT';

        AddAmmoCount(
            'HDShellAmmo',                                    // name
            'SHL1A0',                                         // icon
            (1.0, 1.0),                                       // iconScale
            (-31, -4),                                        // offsets
            (1, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[4];
    }

    override int GetMagCapacity(HDWeapon wpn, HDMagAmmo mag) {
        return wpn.weaponStatus[5];
    }

    override int GetSideSaddleRounds(HDWeapon wpn) {
        return wpn.weaponStatus[3];
    }

    override int GetSideSaddleCapacity(HDWeapon wpn) {
        return 12;
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override Vector2 GetFireModeOffsets(HDWeapon wpn) {
        return (-10, -6);
    }

    override Vector2 GetMagazineRoundsOffsets(HDWeapon wpn) {
        return (0, -1);
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-2, -8);
    }

    override Vector2 GetSideSaddleOffsets(HDWeapon wpn) {
        return (0, 1);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, bool isMag, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.isMag == isMag;
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return !(wpn.weaponStatus[0] & 64);
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return wpn.weaponStatus[2] > 0;
    }

    override bool ShouldDrawSideSaddles(HDWeapon wpn) {
        return GetSideSaddleRounds(wpn) > 0;
    }

    override void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        DrawHorzVectorShell(
            sb, wpn,
            0, color,
            posX, posY,
            scale,
            flags
        );
    }
}
