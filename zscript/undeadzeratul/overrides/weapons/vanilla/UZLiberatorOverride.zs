class UZLiberatorOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'LiberatorRifle';

        magName = 'HD7mMag';
        magCapacity = 30;

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STFULAUT';

        AddMagCount(
            'HD7mMag',                                        // name
            30,                                               // capacity
            'RMAGNORM', 'RMAGEMPTY', 'RMAGNORM', 'RMAGGREY',  // icons
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

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[2];
    }

    override int GetMagAmount(int amount) {
        return amount % 100;
    }

    override int GetMagCapacity(HDWeapon wpn, HDMagAmmo mag) {
        return magCapacity;
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 1;
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-3, -5);
    }

    virtual Vector2 GetChamberedGrenadeOffsets(HDWeapon wpn) {
        return (-4, -9.6);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HD7mMag':       return ammoCounter.type == type;
            case 'HDRocketAmmo':  return ammoCounter.type == type && !(wpn.weaponStatus[0] & 8);
            default:              return false;
        }
    }

    override bool ShouldDrawFullMagazine(int value, int maxValue) {
        return value >= magCapacity;
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return !(wpn.weaponStatus[0] & 1024);
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return wpn.weaponStatus[1] == 2;
    }

    virtual bool ShouldDrawChamberedGrenade(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 4;
    }

    override bool ShouldDrawRangeFinder(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 128;
    }

    override void DrawWeaponStatus(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        super.DrawWeaponStatus(sb, wpn, posX, posY, scale, hudFont, fontColor, fontScale);
                
        if (ShouldDrawChamberedGrenade(wpn)) {
            let offs = GetChamberedGrenadeOffsets(wpn);
            DrawChamberedGrenade(
                sb, wpn,
                Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
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
