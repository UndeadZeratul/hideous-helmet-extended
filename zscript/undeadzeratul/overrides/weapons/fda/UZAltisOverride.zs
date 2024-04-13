class UZAltisOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDAltis';

        fireModes[0] = 'STBURAUT';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'HDSlugAmmo',                                     // name
            'SLG1A0',                                         // icon
            (1.0, 1.0),                                       // iconScale
            (-22, -19),                                       // offsets
            (1, 0),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddAmmoCount(
            'HDShellAmmo',                                    // name
            'SHL1A0',                                         // icon
            (1.0, 1.0),                                       // iconScale
            (-22, -2),                                        // offsets
            (1, 0),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    virtual int GetTopChamberedRound(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    virtual int GetBottomChamberedRound(HDWeapon wpn) {
        return wpn.weaponStatus[2];
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

    override Vector2 GetFireModeOffsets(HDWeapon wpn) {
        return (0, -4);
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-3, 6);
    }

    override Vector2 GetSideSaddleOffsets(HDWeapon wpn) {
        return (5, 1);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type;
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 2;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetTopChamberedRound(wpn) > 0 || GetBottomChamberedRound(wpn) > 0;
    }

    override bool ShouldDrawSideSaddles(HDWeapon wpn) {
        return GetSideSaddleRounds(wpn) > 0;
    }

    override void DrawFireMode(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, int flags) {
        super.DrawFireMode(sb, wpn, posX, posY, scale, sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TRANSLATABLE);
    }

    override void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        let double = ShouldDrawFireMode(wpn);
        
        let topBarrel = GetTopChamberedRound(wpn);
        let bottomBarrel = GetBottomChamberedRound(wpn);

        if (topBarrel) {
            DrawHorzVectorShell(
                sb, wpn,
                GetShellStyle(wpn, !(topBarrel % 2) ? (topBarrel / 2) : -1),
                true,
                Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
                posX, posY - ((18 - (3 * double)) * scale),
                scale,
                flags
            );
        }

        if (bottomBarrel) {
            DrawHorzVectorShell(
                sb, wpn,
                GetShellStyle(wpn, !(bottomBarrel % 2) ? (bottomBarrel / 2) : -1),
                true,
                Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
                posX, posY - ((7 + (4 * double)) * scale),
                scale,
                flags
            );
        }
    }
}
