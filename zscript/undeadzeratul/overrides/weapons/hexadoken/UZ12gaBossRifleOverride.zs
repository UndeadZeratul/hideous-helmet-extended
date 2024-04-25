class UZ12gaBossRifleOverride : UZBossRifleOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'Bossmerg';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'HDShellAmmo',                                    // name
            'SHL1A0',                                         // icon
            (1.0, 1.0),                                       // iconScale
            (-31, -4),                                        // offsets
            (1, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetChamberedRounds(HDWeapon wpn) {
        return wpn.weaponStatus[2];
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[4];
    }

    override int GetMagCapacity(HDWeapon wpn, HDMagAmmo mag) {
        return wpn.weaponStatus[5];
    }

    override int GetSideSaddleRounds(HDWeapon wpn) {
        return wpn.weaponStatus[3];
    }

    override int GetWeaponZoom(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetDropAdjust(HDWeapon wpn) {
        return wpn.weaponStatus[8];
    }

    override string GetFormattedDropAdjust(float dropAdjust) {
        return String.Format("%.1f", dropAdjust * 0.1);
    }

    override Vector2 GetMagazineRoundsOffsets(HDWeapon wpn) {
        return (0, -1);
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-2, -8);
    }

    override Vector2 GetWeaponZoomOffsets(HDWeapon wpn) {
        return (-16, -16);
    }

    override Vector2 GetDropAdjustOffsets(HDWeapon wpn) {
        return (0, -16);
    }

    override Vector2 GetSideSaddleOffsets(HDWeapon wpn) {
        return (0, 1);
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HDShellAmmo': return ammoCounter.type == type;
            default:            return false;
        }
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn) > 0;
    }

    override bool ShouldDrawSideSaddles(HDWeapon wpn) {
        return GetSideSaddleRounds(wpn) > 0;
    }
    override void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        DrawHorzVectorShell(
            sb, wpn,
            GetShellStyle(wpn, GetChamberedRounds(wpn) > 1 ? 0 : -1),
            false,
            color,
            posX, posY,
            scale,
            flags
        );
    }
}
