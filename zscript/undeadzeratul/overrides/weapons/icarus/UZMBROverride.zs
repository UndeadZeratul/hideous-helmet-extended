class UZMBROverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDMBR';

        magCapacity = 20;

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STFULAUT';
        fireModes[2] = 'STBURAUT';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'HDMBRMagLight',                                  // name
            20,                                               // capacity
            '5LMGA0', '5LMGB0', '5LMGNORM', '5MAGGREY',       // icons
            (1.0, 1.0),                                       // iconScale
            (-4, 1),                                         // offsets
            (2, -3),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddMagCount(
            'HDMBRMagHeavy',                                  // name
            20,                                               // capacity
            '5HMGA0', '5HMGB0', '5HMGNORM', '5HMGGREY',       // icons
            (1.0, 1.0),                                       // iconScale
            (-19, 1),                                         // offsets
            (2, -3),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

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

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[4];
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[2];
    }

    override Vector2 GetFireModeOffsets(HDWeapon wpn) {
        return (-6, -15);
    }

    override Vector2 GetMagazineRoundsOffsets(HDWeapon wpn) {
        return (0, -10);
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-3, -15);
    }

    virtual Vector2 GetChamberedGrenadeOffsets(HDWeapon wpn) {
        return (-4, -18.6);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HDMBRMagLight': return ammoCounter.type == type;
            case 'HDMBRMagHeavy': return ammoCounter.type == type;
            case 'HDRocketAmmo':  return ammoCounter.type == type && (wpn.weaponStatus[0] & 16);
            default:              return false;
        }
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 4;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn) == 2 || GetChamberedRounds(wpn) == 4;
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
