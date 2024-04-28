class UZBitchOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDBitch';

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STBURAUT';
        fireModes[2] = 'STFULAUT';
        fireModes[3] = 'STHPRAUT';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'HDRocketAmmo',                                   // name
            'ROQPA0',                                         // icon
            (0.6, 0.6),                                       // iconScale
            (-34, 2),                                         // offsets
            (2, -4),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetChamberedRounds(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    virtual int GetChamberedGrenade(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 4;
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[2];
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-6, -2);
    }

    virtual Vector2 GetChamberedGrenadeOffsets(HDWeapon wpn) {
        return (-6, -7);
    }

    override Vector2 GetFireModeOffsets(HDWeapon wpn) {
        return (-10, 1);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HDRocketAmmo': return ammoCounter.type == type && wpn.weaponStatus[0] & 8;
            default:             return false;
        }
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn) == 1;
    }

    virtual bool ShouldDrawChamberedGrenade(HDWeapon wpn) {
        return GetChamberedGrenade(wpn);
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

    override void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        sb.Fill(
            color,
            posX, posY,
            6 * scale, 3 * scale,
            flags
        );

        sb.Fill(
            color,
            posX - scale, posY + scale,
            scale, scale,
            flags
        );
    }

    virtual void DrawChamberedGrenade(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        sb.Fill(
            color,
            posX, posY,
            6 * scale, 3 * scale,
            flags
        );
    }
}
