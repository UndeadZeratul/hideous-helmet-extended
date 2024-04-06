class UZBossRifleOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'BossRifle';

        // magName = 'HD7mClip';
        magCapacity = 10;

        AddMagCount(
            'HD7mClip',                                       // name
            50,                                               // capacity
            'RCLPA0', 'RCLPF0', 'RCLPA0', 'RCLPE0',           // icons
            (1.2, 1.2),                                       // iconScale
            (-34, 3),                                         // offsets
            (7, -5),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddAmmoCount(
            'SevenMilAmmo',                                   // name
            'TEN7A0',                                         // icon
            (1.0, 1.0),                                       // iconScale
            (-46, 2),                                         // offsets
            (6, -4),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddAmmoCount(
            'SevenMilAmmoRecast',                             // name
            'TEN7A0',                                         // icon
            (1.0, 1.0),                                       // iconScale
            (-46, -8),                                        // offsets
            (6, -4),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetChamberedRounds(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[2];
    }

    override int GetWeaponZoom(HDWeapon wpn) {
        return wpn.weaponStatus[3];
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (0, -4);
    }

    override Vector2 GetWeaponZoomOffsets(HDWeapon wpn) {
        return (-20, -12);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HD7mClip':           return true;
            case 'SevenMilAmmo':       return true;
            case 'SevenMilAmmoRecast': return !!item;
            default:                   return false;
        }
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn);
    }

    override bool ShouldDrawWeaponZoom(HDWeapon wpn) {
        return GetWeaponZoom(wpn);
    }

    override void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        let chamber = GetChamberedRounds(wpn);
        let sprite = '';

        switch (chamber) {
            case 4:
            case 3:
                sprite = 'STRNDJAM';
                break;
            case 2:
                sprite = 'STRNDCMB';
                break;
            case 1:
                sprite = 'STRNDFRD';
                break;
            case 0:
            default:
                break;
        }

        if (sprite != '') {
            sb.DrawImage(
                sprite,
                (posX, posy),
                flags: flags|sb.DI_ITEM_RIGHT,
                scale: (scale, scale)
            );
        }
    }

    override void DrawWeaponZoom(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {
        sb.DrawString(
            hudFont,
            String.Format("%.1f", GetWeaponZoom(wpn) * 0.1),
            (posX, posY),
            flags,
            Font.CR_DARKGRAY,
            scale: (fontScale * scale, fontScale * scale)
        );
        
        // TODO: Extract DropAdjust
        sb.DrawString(
            hudFont,
            sb.FormatNumber(wpn.weaponStatus[4]),
            (posX + (20 * scale), posY),
            flags,
            Font.CR_WHITE,
            scale: (fontScale * scale, fontScale * scale)
        );
    }
}
