class UZZM66Override : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'ZM66AssaultRifle';

        magName = 'HD4mMag';
        magCapacity = 50;

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STFULAUT';
        fireModes[2] = 'STBURAUT';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'HD4mMag',                                        // name
            50,                                               // capacity
            'ZMAGA0', 'ZMAGC0', 'ZMAGNORM', 'ZMAGGREY',       // icons
            (2.0, 2.0),                                       // iconScale
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

    override int GetMagAmount(int amount) {
        // Coerce the magazine value into the size of the 4mm Mag
        return clamp(amount % 100, 0, magCapacity);
    }

    override int GetAmmoCounter(HDWeapon wpn, HDMagAmmo mag) {
        int magAmt = GetMagAmount(GetMagRounds(wpn));

        // If the magazine that's inserted is dirty, randomize the counter value.
        // Otherwise draw the amount in the mag as well as the chambered round, if any.
        return magAmt > 100 ? random[shitgun](10,99) : magAmt + GetChamberedRounds(wpn);
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[2];
    }

    override int GetWeaponZoom(HDWeapon wpn) {
        return wpn.weaponStatus[3];
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
            case 'HD4mMag':       return ammoCounter.type == type;
            case 'HDRocketAmmo':  return ammoCounter.type == type && !(wpn.weaponStatus[0] & 16);
            default:              return false;
        }
    }

    override bool ShouldDrawFullMagazine(int value, int maxValue) {
        return value > magCapacity;
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return !(wpn.weaponStatus[0] & 32);
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawAmmoCounter(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn);
    }

    virtual bool ShouldDrawChamberedGrenade(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 8;
    }

    override bool ShouldDrawRangeFinder(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 64;
    }

    override bool ShouldDrawWeaponZoom(HDWeapon wpn) {
        return !ShouldDrawRangeFinder(wpn) && GetWeaponZoom(wpn);
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
