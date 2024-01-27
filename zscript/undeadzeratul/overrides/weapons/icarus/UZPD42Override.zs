class UZPD42Override : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDPDFour';

        magName = 'HDPDFourMag';
        magCapacity = 36;

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STBURAUT';
        fireModes[2] = 'STFULAUT';

        AddMagCount(
            'HDPDFourMag',                                    // name
            36,                                               // capacity
            'PDMGA0', 'PDMGB0', 'PDMGNORM', 'PDMGGREY',       // icons
            (1.0, 1.0),                                       // iconScale
            (-30, 3),                                         // offsets
            (3, -5),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddAmmoCount(
            'HDSlugAmmo',                                     // name
            'SLG1A0',                                         // icon
            (1.0, 1.0),                                       // iconScale
            (-43, -4),                                        // offsets
            (1, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[3];
    }

    virtual Vector2 GetChamberedSlugOffsets(HDWeapon wpn) {
        return (-4, -9);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HDPDFourMag': return ammoCounter.type == type;
            case 'HDSlugAmmo':  return ammoCounter.type == type && wpn.weaponStatus[0] & 4;
            default:            return false;
        }
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return wpn.weaponStatus[2];
    }

    virtual bool ShouldDrawChamberedSlug(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 2;
    }

    override void DrawWeaponStatus(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        super.DrawWeaponStatus(sb, wpn, posX, posY, scale, hudFont, fontColor, fontScale);

        if (ShouldDrawChamberedSlug(wpn)) {
            let offs = GetChamberedSlugOffsets(wpn);
            DrawChamberedSlug(
                sb, wpn,
                0, Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
                posX + (offs.x * scale),
                posY + (offs.y * scale),
                scale,
                sb.DI_SCREEN_CENTER_BOTTOM
            );
        }
    }

    virtual void DrawChamberedSlug(HCStatusBar sb, HDWeapon wpn, int style, Color color, int posX, int posY, float scale, int flags) {
        switch (style) {
            case 0:
                sb.Fill(
                    color,
                    posX, posY,
                    4 * scale, 2.6 * scale,
                    flags
                );
                break;
            case 1:
                DrawHorzVectorShell(
                    sb, wpn,
                    2, color,
                    posX + (2 * scale),
                    posY,
                    scale,
                    flags
                );
                break;
        }
    }
}
