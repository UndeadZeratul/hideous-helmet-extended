class UZFrontiersmanOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDFrontier';

        magCapacity = 5;

        fireModes[0] = 'blank';
        fireModes[1] = 'HOLYBLT';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'SevenMilAmmo',                                   // name
            'TEN7A0',                                         // icon
            (1.2, 1.2),                                       // iconScale
            (-38, 2),                                         // offsets
            (4, -4),                                          // countOffsets
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

    override int GetMagCapacity(HDWeapon wpn, HDMagAmmo mag) {
        return magCapacity;
    }

    override int GetSideSaddleRounds(HDWeapon wpn) {
        return wpn.weaponStatus[3];
    }

    override int GetSideSaddleCapacity(HDWeapon wpn) {
        return 15;
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[4];
    }

    override Vector2 GetFireModeOffsets(HDWeapon wpn) {
        return (0, -10);
    }

    override Vector2 GetMagazineRoundsOffsets(HDWeapon wpn) {
        return (0, -3);
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-6, -7);
    }

    override Vector2 GetSideSaddleOffsets(HDWeapon wpn) {
        return (0, 1);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type;
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn) > 0;
    }

    override bool ShouldDrawSideSaddles(HDWeapon wpn) {
        return GetSideSaddleRounds(wpn) > 0;
    }

    override void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {

        sb.Fill(
            color,
            posX, posY,
            5 * scale, 3 * scale,
            flags
        );

        if (GetChamberedRounds(wpn)) {
            sb.Fill(
                color,
                posX - (2 * scale), posY,
                2 * scale, 3 * scale,
                flags
            );

            sb.Fill(
                color,
                posX - (3 * scale), posY + scale,
                scale, scale,
                flags
            );
        }
    }

    override void DrawMagazineRounds(HCStatusBar sb, HDWeapon wpn, int value, int maxValue, bool precise, Color color, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {

        for (let i = GetMagRounds(wpn); i > 0; i--) {
            sb.Fill(
                color,
                posX - (i * 6 * scale), posY,
                5 * scale, 3 * scale,
                flags
            );
        }
    }
}
