class UZPD42Override : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDPDFour';
        magName = 'HDPDFourMag';
        ammoName = 'HDSlugAmmo';

        magCapacity = 36;

        magIconFull = 'PDMGA0';
        magIconEmpty = 'PDMGB0';
        magIconFG = 'PDMGNORM';
        magIconBG = 'PDMGGREY';

        ammoIcon = 'SLG1A0';

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STBURAUT';
        fireModes[2] = 'STFULAUT';

        style = CHAMBER_AND_MAG;
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[3];
    }

    virtual Vector2 GetChamberedSlugOffsets() {
        return (-4, -9);
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
            let offs = GetChamberedSlugOffsets();
            DrawChamberedSlug(sb, wpn, posX + (offs.x * scale), posY + (offs.y * scale), scale);
        }
    }

    override void DrawMagazine(HCStatusBar sb, HDWeapon wpn, HDMagAmmo mag, int value, int maxValue, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        super.DrawMagazine(sb, wpn, mag, value, maxValue, posX, posY, scale, hudFont, fontColor, fontScale);
        
        if (wpn.weaponStatus[0] & 4) {
            sb.DrawImage(
                ammoIcon,
                (posX - (13 * scale), posY - (5 * scale)),
                sb.DI_SCREEN_CENTER_BOTTOM,
                scale: (ammoScale.x * scale, ammoScale.y * scale)
            );

            sb.DrawString(
                hudFont,
                sb.FormatNumber(sb.hpl.CountInv(ammoName)),
                (posX - (12 * scale), posY - (5 * scale)),
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT,
                fontColor,
                scale: (fontScale * scale, fontScale * scale)
            );
        }
    }

    virtual void DrawChamberedSlug(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale) {
        sb.DrawRect(posX, posY, 4 * scale, 2.6 * scale);
    }
}
