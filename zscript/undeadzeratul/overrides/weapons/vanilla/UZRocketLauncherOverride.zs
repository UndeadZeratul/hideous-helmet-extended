class UZRocketLauncherOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDRL';

        magCapacity = 6;

        AddAmmoCount(
            'HDRocketAmmo',                                   // name
            'ROQPA0',                                         // icon
            (0.6, 0.6),                                       // iconScale
            (-31, 2),                                         // offsets
            (6, -4),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddAmmoCount(
            'HEATAmmo',                                       // name
            'ROCKA0',                                         // icon
            (0.6, 0.6),                                       // iconScale
            (-42, 2),                                         // offsets
            (4, -4),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetChamberedRounds(HDWeapon wpn) {
        return wpn.weaponStatus[2];
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 2;
    }

    override Vector2 GetFireModeOffsets(HDWeapon wpn) {
        return (-2, -10);
    }

    // override Vector2 GetMagazineRoundsOffsets(HDWeapon wpn) {
    //     return (0, 0);
    // }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-3, -5);
    }

    override Vector2 GetRangeFinderOffsets(HDWeapon wpn) {
        return (-6, -3);
    }

    override Vector2 GetRangeFinderTextOffsets(HDWeapon wpn) {
        return (-10, -6);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type;
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return !GetFireMode(wpn);
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return !(wpn.weaponStatus[0] & 4);
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn) > 0;
    }

    override bool ShouldDrawRangeFinder(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawRangeFinderBar(HDWeapon wpn) {
        return !(GetChamberedRounds(wpn) > 1 || !GetFireMode(wpn));
    }

    override bool ShouldDrawRangeFinderText(HDWeapon wpn) {
        return GetChamberedRounds(wpn) <= 1 && wpn.airburst;
    }

    override void DrawFireMode(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, int flags) {
        let color = Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b);

        if (GetChamberedRounds(wpn) > 1) {
            sb.Fill(
                color,
                posX - (4 * scale), posY + scale,
                3 * scale, 2 * scale,
                flags
            );
            sb.Fill(
                color,
                posX, posY + scale,
                2 * scale, 2 * scale,
                flags
            );
            sb.Fill(
                color,
                posX - (8 * scale), posY - scale,
                4 * scale, 6 * scale,
                flags
            );
            sb.Fill(
                color,
                posX - (12 * scale), posY,
                4 * scale, 4 * scale,
                flags
            );
        } else {
            sb.Fill(
                color,
                posX - (4 * scale), posY + (3 * scale),
                3 * scale, scale,
                flags
            );
            sb.Fill(
                color,
                posX, posY + (3 * scale),
                2 * scale, scale,
                flags
            );
            sb.Fill(
                color,
                posX - (8 * scale), posY + (2 * scale),
                4 * scale, 3 * scale,
                flags
            );
        }
    }

    override void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        sb.Fill(
            color,
            posX, posY,
            3 * scale, 1 * scale,
            flags
        );
    }
}
