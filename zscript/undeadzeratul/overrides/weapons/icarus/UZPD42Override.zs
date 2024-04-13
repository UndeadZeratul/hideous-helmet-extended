class UZPD42Override : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDPDFour';

        magName = 'HDPDFourMag';
        magCapacity = 36;

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STBURAUT';
        fireModes[2] = 'STFULAUT';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
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

    virtual int GetChamberedSlug(HDWeapon wpn) {
        return wpn.weaponStatus[5];
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[3];
    }

    override Vector2 GetFireModeOffsets(HDWeapon wpn) {
        return (-9, -4);
    }

    virtual Vector2 GetChamberedSlugOffsets(HDWeapon wpn) {
        return (-2, -9);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HDPDFourMag': return ammoCounter.type == type;
            case 'HDSlugAmmo':  return ammoCounter.type == type && wpn.weaponStatus[0] & 2;
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
        return GetChamberedSlug(wpn);
    }

    override void DrawWeaponStatus(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        super.DrawWeaponStatus(sb, wpn, posX, posY, scale, hudFont, fontColor, fontScale);

        if (ShouldDrawChamberedSlug(wpn)) {
            let offs = GetChamberedSlugOffsets(wpn);
            let barrel = GetChamberedSlug(wpn);
            DrawHorzVectorShell(
                sb, wpn,
                GetShellStyle(wpn, !(barrel % 2) ? 2 : -1),
                false,
                Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
                posX + (offs.x * scale),
                posY + (offs.y * scale),
                scale,
                sb.DI_SCREEN_CENTER_BOTTOM
            );
        }
    }
}
