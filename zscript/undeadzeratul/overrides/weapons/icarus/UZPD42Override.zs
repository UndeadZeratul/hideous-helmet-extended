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
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[3];
    }

    override Vector2 GetAmmoOffsets() {
        return (-43, 2);
    }

    virtual Vector2 GetChamberedSlugOffsets() {
        return (-4, -9);
    }

    override bool ShouldDrawMagazine(HDWeapon wpn, HDMagAmmo mag) {
        return true;
    }

    override bool ShouldDrawAmmo(HDWeapon wpn, HDAmmo ammo) {
        return wpn.weaponStatus[0] & 4;
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
            let offs = GetChamberedSlugOffsets();
            DrawChamberedSlug(sb, wpn, posX + (offs.x * scale), posY + (offs.y * scale), scale);
        }
    }

    virtual void DrawChamberedSlug(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale) {
        sb.DrawRect(posX, posY, 4 * scale, 2.6 * scale);
    }
}
