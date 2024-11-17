class UZDMROverride : UZZM66Override {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDDMR';


        fireModes[0] = '';
        fireModes[1] = '';
        fireModes[2] = '';
    }

    override int GetChamberedRounds(HDWeapon wpn) {
        return wpn.weaponStatus[2] >= 2;
    }

    override string GetFormattedWeaponZoom(float zoom) {
        return String.Format("%.1f", zoom * 0.1);
    }

    override int GetDropAdjust(HDWeapon wpn) {
        return wpn.weaponStatus[4];
    }

    override Vector2 GetWeaponZoomOffsets(HDWeapon wpn) {
        return (-26, -14);
    }

    override Vector2 GetDropAdjustOffsets(HDWeapon wpn) {
        return (-10, -14);
    }

    override HUDFont GetWeaponZoomFont(HCStatusBar sb, HDWeapon wpn, HUDFont hudFont) {
        return sb.mAmountFont;
    }

    override HUDFont GetDropAdjustFont(HCStatusBar sb, HDWeapon wpn, HUDFont hudFont) {
        return sb.mAmountFont;
    }

    override Vector2 GetWeaponZoomFontScale(HCStatusBar sb, HDWeapon wpn, HUDFont hudFont, float fontScale) {
        return hudFont == sb.mAmountFont ? (1.0, 1.0) : (fontScale, fontScale);
    }

    override Vector2 GetDropAdjustFontScale(HCStatusBar sb, HDWeapon wpn, HUDFont hudFont, float fontScale) {
        return hudFont == sb.mAmountFont ? (1.0, 1.0) : (fontScale, fontScale);
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HD4mMag': return ammoCounter.type == type;
            default:        return false;
        }
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn);
    }

    override bool ShouldDrawWeaponZoom(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawDropAdjust(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawChamberedGrenade(HDWeapon wpn) {
        return false;
    }
}
