class UZFP45Override : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDFP45';

    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'HD45ACPAmmo',                                    // name
            '45RNA0',                                         // icon
            (2.1, 2.1),                                       // iconScale
            (-30, -4),                                        // offsets
            (2, 2),                                           // countOffsets
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

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-4, -5);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn) > 0;
    }

    override void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        if (GetChamberedRounds(wpn) > 1) {
            sb.Fill(
                color,
                posX - (3 * scale), posY,
                2 * scale, 2 * scale,
                flags
            );
        }
        
        sb.Fill(
            color,
            posX, posY,
            3 * scale, 2 * scale,
            flags
        );
    }

    override void DrawMagazineRounds(HCStatusBar sb, HDWeapon wpn, int value, int maxValue, bool precise, Color color, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {
        for (int i = value; i > 0; i--) {
            sb.Fill(
                color,
                posX - (i * 4 * scale), posY - (2 * scale),
                2 * scale, 4 * scale,
                flags
            );

            sb.Fill(
                color,
                posX - (i * 4 * scale), posY + (3 * scale),
                2 * scale, 1 * scale,
                flags
            );
        }
    }
}
