class UZVulcanetteOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'Vulcanette';

        magName = 'HD4mMag';
        magCapacity = 50;

        fireModes[0] = 'blank';
        fireModes[1] = 'STFULAUT';
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

        AddBatteryCount(
            'HDBattery',                                      // name
            20,                                               // capacity
            'CELLA0', 'CELLB0', 'CELLC0', 'CELLD0',           // icons
            (1.0, 1.0),                                       // iconScale
            (-48, 2),                                         // offsets
            (8, -4),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetChamberedRounds(HDWeapon wpn) {
        return wpn.weaponStatus[6]
            + wpn.weaponStatus[7]
            + wpn.weaponStatus[8]
            + wpn.weaponStatus[9]
            + wpn.weaponStatus[10];
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetBatteryCharge(HDWeapon wpn) {
        return wpn.weaponStatus[11];
    }

    override int GetMagAmount(int amount) {
        // Coerce the magazine value into the size of the 4mm Mag
        return clamp(amount % 100, 0, magCapacity);
    }

    override int GetAmmoCounter(HDWeapon wpn, HDMagAmmo mag) {
        int magAmt = GetMagAmount(GetMagRounds(wpn));

        // If the magazine that's inserted is dirty, randomize the counter value.
        // Otherwise draw the amount in the mag.
        return magAmt > 100 ? random[shitgun](10,99) : magAmt;
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 1;
    }

    override int GetWeaponZoom(HDWeapon wpn) {
        return wpn.weaponStatus[12];
    }

    override Vector2 GetFireModeOffsets(HDWeapon wpn) {
        return (-12, -10);
    }

    override Vector2 GetMagazineRoundsOffsets(HDWeapon wpn) {
        return (0, -3);
    }

    override Vector2 GetAmmoCounterOffsets(HDWeapon wpn) {
        return (-4, -16);
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (1, -8);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HD4mMag':   return ammoCounter.type == type;
            case 'HDBattery': return ammoCounter.type == type;
            default:          return false;
        }
    }

    override bool ShouldDrawFullMagazine(int value, int maxValue) {
        return value > magCapacity;
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawBatteryCharge(HDWeapon wpn, HDMagAmmo mag) {
        return GetBatteryCharge(wpn) >= 0;
    }

    override bool ShouldDrawAmmoCounter(HDWeapon wpn) {
        return GetBatteryCharge(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn);
    }

    override bool ShouldDrawWeaponZoom(HDWeapon wpn) {
        return GetWeaponZoom(wpn);
    }

    override void DrawWeaponStatus(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        super.DrawWeaponStatus(sb, wpn, posX, posY, scale, hudFont, fontColor, fontScale);

        // Draw extra loaded magazines
        for (int i = 1; i <= 4; i++) {
            if (wpn.weaponStatus[i + 1] >= 0) {
                sb.Fill(
                    Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
                    posX - ((3 + (4 * i)) * scale), posY - (8 * scale),
                    3 * scale, 2 * scale,
                    SB.DI_SCREEN_CENTER_BOTTOM
                );
            }
        }
    }

    override void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        for (int i = 0; i < 5; i++) {
            if (wpn.weaponStatus[i + 6] > 0) {
                sb.Fill(
                    color,
                    posX, posY + ((2 * i) * scale),
                    scale, scale,
                    flags
                );
            }
        }
    }
}
