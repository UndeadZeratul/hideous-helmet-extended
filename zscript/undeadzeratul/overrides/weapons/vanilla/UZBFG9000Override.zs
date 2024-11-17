class UZBFG9KOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'BFG9K';

        magName = 'HDBattery';
        magCapacity = 20;
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddBatteryCount(
            'HDBattery',                                      // name
            20,                                               // capacity
            'CELLA0', 'CELLB0', 'CELLC0', 'CELLD0',           // icons
            (1.0, 1.0),                                       // iconScale
            (-38, 2),                                         // offsets
            (8, -4),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[2];
    }

    override int GetBatteryCharge(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 1;
    }

    override Vector2 GetFireModeOffsets(HDWeapon wpn) {
        return (-10, -11);
    }

    override Vector2 GetMagazineRoundsOffsets(HDWeapon wpn) {
        return (0, -6);
    }

    override Vector2 GetBatteryChargeOffsets(HDWeapon wpn) {
        return (0, 0);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type;
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 1;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) >= 0;
    }

    override bool ShouldDrawBatteryCharge(HDWeapon wpn, HDMagAmmo mag) {
        return GetBatteryCharge(wpn) >= 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return false;
    }

    override void DrawFireMode(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, int flags) {
        let color = GetBaseVectorColor(sb);

        sb.Fill(
            color,
            posX, posY,
            10 * scale, scale,
            flags
        );
        sb.Fill(
            color,
            posX + (2 * scale), posY - (3 * scale),
            8 * scale, scale,
            flags
        );
        sb.Fill(
            color,
            posX + (5 * scale), posY - (6 * scale),
            5 * scale, scale,
            flags
        );
    }

    override void DrawMagazineRounds(HCStatusBar sb, HDWeapon wpn, int value, int maxValue, bool precise, Color color, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {
        DrawBatteryCharge(sb, wpn, value, maxValue, precise, color, posX, posY, scale, hudFont, fontColor, fontScale, flags);
    }

    override void DrawBatteryCharge(HCStatusBar sb, HDWeapon wpn, int value, int maxValue, bool precise, Color color, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {
        if (value > 0) {
            super.DrawMagazineRounds(sb, wpn, value, maxValue, precise, color, posX, posY, scale, hudFont, fontColor, fontScale, flags);
        } else {
            sb.DrawString(
                GetEmptyBatteryFont(sb, wpn, hudFont),
                "00000",
                (posX, posY - scale),
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TRANSLATABLE|sb.DI_TEXT_ALIGN_RIGHT,
                GetEmptyBatteryFontColor(wpn),
                scale: (scale, scale)
            );
        }
    }
}
