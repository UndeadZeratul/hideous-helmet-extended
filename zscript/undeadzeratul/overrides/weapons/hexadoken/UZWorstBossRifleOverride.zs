class UZWorstBossRifleOverride : UZBossRifleOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'BossRifleButItsTheWorst';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'SevenMilAmmo',                                   // name
            '7RNDA0',                                         // icon
            (2.1, 2.1),                                       // iconScale
            (-38, -4),                                        // offsets
            (3, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override string GetFormattedDropAdjust(float dropAdjust) {
        return String.Format("%.1f", dropAdjust * 0.1);
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-3, -3);
    }

    override void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        let chamber = GetChamberedRounds(wpn);

        if (chamber) {
            if (!(chamber % 2)) {
                sb.Fill(
                    color,
                    posX - (21 * scale), posY + scale,
                    scale, 2 * scale,
                    flags
                );

                sb.Fill(
                    color,
                    posX - (20 * scale), posY,
                    6 * scale, 4 * scale,
                    flags
                );
            }

            sb.Fill(
                color,
                posX - (13 * scale), posY,
                12 * scale, 4 * scale,
                flags
            );
            
            sb.Fill(
                color,
                posX, posY,
                2 * scale, 4 * scale,
                flags
            );
        }
    }
}
