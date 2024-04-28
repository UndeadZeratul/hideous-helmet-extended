class UZGreelyOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDGreely';

        magCapacity = 3;
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'HDShellAmmo',                                    // name
            'SHL1A0',                                         // icon
            (1.0, 1.0),                                       // iconScale
            (-31, -4),                                        // offsets
            (1, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddAmmoCount(
            'HDSlugAmmo',                                     // name
            'SLG1A0',                                         // icon
            (1.0, 1.0),                                       // iconScale
            (-41, -4),                                        // offsets
            (1, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetChamberedRounds(HDWeapon wpn) {
        return wpn.weaponStatus[4];
    }

    override int GetMagRounds(HDWeapon wpn) {
        return !!wpn.weaponStatus[1] + !!wpn.weaponStatus[2] + !!wpn.weaponStatus[3];
    }

    override int GetMagCapacity(HDWeapon wpn, HDMagAmmo mag) {
        return magCapacity;
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-1, -8);
    }

    override Vector2 GetMagazineRoundsOffsets(HDWeapon wpn) {
        return (-1, -4);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn);
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn);
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type;
    }

    override void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        let barrel = GetChamberedRounds(wpn);

        DrawHorzVectorShell(
            sb, wpn,
            GetShellStyle(wpn, barrel > 2 ? barrel / 2 : -1),
            false,
            color,
            posX, posY,
            scale,
            flags
        );
    }

    override void DrawMagazineRounds(HCStatusBar sb, HDWeapon wpn, int value, int maxValue, bool precise, Color color, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {

        for (let i = 0; i < GetMagCapacity(wpn, null); i++) {
            let tube = wpn.weaponStatus[i + 1];

            if (tube > 2) {
                DrawHorzVectorShell(
                    sb, wpn,
                    GetShellStyle(wpn, tube / 2),
                    false,
                    color,
                    posX - (9 * i * scale), posY,
                    scale,
                    flags
                );
            }
        }
    }
}
