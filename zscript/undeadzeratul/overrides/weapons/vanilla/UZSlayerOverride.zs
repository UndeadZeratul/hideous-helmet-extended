class UZSlayerOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'Slayer';

        fireModes[0] = 'STBURAUT';

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

    virtual int GetLeftChamberedRound(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    virtual int GetRightChamberedRound(HDWeapon wpn) {
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
        return (-7, -11);
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (0, -3);
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
        return GetLeftChamberedRound(wpn) > 0 || GetRightChamberedRound(wpn) > 0;
    }

    override bool ShouldDrawSideSaddles(HDWeapon wpn) {
        return GetSideSaddleRounds(wpn) > 0;
    }

    override void DrawFireMode(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, int flags) {
        super.DrawFireMode(sb, wpn, posX, posY, scale, sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TRANSLATABLE);
    }

    override void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        let double = ShouldDrawFireMode(wpn);
        
        let leftBarrel = GetLeftChamberedRound(wpn);
        let rightBarrel = GetRightChamberedRound(wpn);

        if (leftBarrel) {
            DrawVertVectorShell(
                sb, wpn,
                leftBarrel > 1 ? 0 : -1, Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
                posX + ((-15 + (4 * double)) * scale), posY,
                scale,
                flags
            );
        }

        if (rightBarrel) {
            DrawVertVectorShell(
                sb, wpn,
                rightBarrel > 1 ? 0 : -1, Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
                posX - ((2 + (4 * double + double)) * scale), posY,
                scale,
                flags
            );
        }
    }
}
