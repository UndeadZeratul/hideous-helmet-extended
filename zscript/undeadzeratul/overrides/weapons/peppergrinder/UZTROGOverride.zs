class UZTROGOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDTROGRifle';

        magName = 'HDTrogmag';
        magCapacity = 30;

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STFULAUT';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'HDTrogmag',                                      // name
            30,                                               // capacity
            'TMAGA0', 'TMAGC0', 'TMAGNORM', 'TMAGGREY',       // icons
            (1.0, 1.0),                                       // iconScale
            (-30, 3),                                         // offsets
            (3, -5),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddAmmoCount(
            'HDRocketAmmo',                                   // name
            'ROQPA0',                                         // icon
            (0.6, 0.6),                                       // iconScale
            (-46, 2),                                         // offsets
            (6, -4),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetChamberedRounds(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 1;
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[2];
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-3, -4);
    }

    virtual Vector2 GetChamberedGrenadeOffsets(HDWeapon wpn) {
        return (-4, -8);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HDTrogmag':     return ammoCounter.type == type;
            case 'HDRocketAmmo':  return ammoCounter.type == type;
            default:              return false;
        }
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn);
    }

    virtual bool ShouldDrawChamberedGrenade(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 2;
    }

    override void DrawWeaponStatus(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        super.DrawWeaponStatus(sb, wpn, posX, posY, scale, hudFont, fontColor, fontScale);

        if (ShouldDrawChamberedGrenade(wpn)) {
            let offs = GetChamberedGrenadeOffsets(wpn);
            DrawChamberedGrenade(
                sb, wpn,
                GetChamberedRoundColor(sb, wpn),
                posX + (offs.x * scale),
                posY + (offs.y * scale),
                scale,
                sb.DI_SCREEN_CENTER_BOTTOM
            );
        }
    }

    virtual void DrawChamberedGrenade(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        sb.Fill(
            color,
            posX, posY,
            4 * scale, 2.6 * scale,
            flags
        );
    }
}
