class UZBPXOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDBPX';

        magName = 'HD9mMag15';
        magCapacity = 15;
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'HD9mMag15',                                      // name
            15,                                               // capacity
            'CLP2NORM', 'CLP2EMPTY', 'CLP2NORM', 'CLP2GREY',  // icons
            (1.0, 1.0),                                       // iconScale
            (-30, 3),                                         // offsets
            (3, -5),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetChamberedRounds(HDWeapon wpn) {
        return wpn.weaponStatus[2];
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    virtual int GetSaddledMags(HDWeapon wpn) {
        return (wpn.weaponStatus[7] >= 0) + (wpn.weaponStatus[8] >= 0) + (wpn.weaponStatus[9] >= 0);
    }

    override int GetWeaponZoom(HDWeapon wpn) {
        return wpn.weaponStatus[4];
    }

    override string GetFormattedWeaponZoom(float zoom) {
        return String.Format("%.1f", zoom * 0.1);
    }

    override int GetDropAdjust(HDWeapon wpn) {
        return wpn.weaponStatus[5];
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-3, -5);
    }

    override Vector2 GetWeaponZoomOffsets(HDWeapon wpn) {
        return (-20, -18);
    }

    override Vector2 GetDropAdjustOffsets(HDWeapon wpn) {
        return (0, -18);
    }

    virtual Vector2 GetSaddledMagsOffsets(HDWeapon wpn) {
        return (-3, -8);
    }

    virtual Color GetSaddledMagColor(HCStatusBar sb, HDWeapon wpn) {
        return GetBaseVectorColor(sb);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HD9mMag15': return ammoCounter.type == type;
            default:          return false;
        }
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn) == 2;
    }

    override bool ShouldDrawWeaponZoom(HDWeapon wpn) {
        return wpn.weaponStatus[6] >= 2;
    }

    override bool ShouldDrawDropAdjust(HDWeapon wpn) {
        return wpn.weaponStatus[6] >= 2;
    }

    virtual bool ShouldDrawSaddledMags(HDWeapon wpn) {
        return GetSaddledMags(wpn) > 0;
    }

    override void DrawWeaponStatus(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        super.DrawWeaponStatus(sb, wpn, posX, posY, scale, hudFont, fontColor, fontScale);

        if (ShouldDrawSaddledMags(wpn)) {
            DrawSaddledMags(
                sb, wpn, 
                GetSaddledMagColor(sb, wpn),
                GetSaddledMags(wpn),
                posX,
                posY,
                GetSaddledMagsOffsets(wpn),
                scale,
                sb.DI_SCREEN_CENTER_BOTTOM
            );
        }
    }

    virtual void DrawSaddledMags(HCStatusBar sb, HDWeapon wpn, Color color, int numMags, int posX, int posY, Vector2 offs, float scale, int flags) {
        for (let i = 0; i < numMags; i++) {
            DrawSaddledMag(
                sb,
                wpn,
                color,
                posX + (-4 * i * scale) + (offs.x * scale),
                posY                    + (offs.y * scale),
                scale,
                flags
            );
        }
    }

    virtual void DrawSaddledMag(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        sb.Fill(
            color,
            posX, posY,
            3 * scale, 2 * scale,
            flags
        );
    }
}
