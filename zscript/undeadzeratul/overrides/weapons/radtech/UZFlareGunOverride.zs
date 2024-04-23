class UZFlareGunOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'FireBlooper';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'HDFlareAmmo',                                    // name
            'FLARA0',                                         // icon
            (0.6, 0.6),                                       // iconScale
            (-32, 2),                                         // offsets
            (3, -4),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddAmmoCount(
            'HDShellAmmo',                                    // name
            'SHL1A0',                                         // icon
            (1.1, 1.1),                                       // iconScale
            (-17, 2),                                         // offsets
            (3, -4),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetChamberedRounds(HDWeapon wpn) {
        return wpn.weaponStatus[0];
    }

    override int GetVanillaShellStyle(HDweapon wpn, int state) {
        let barrel = GetChamberedRounds(wpn);

        if (barrel & (2|8|32))       return 0;  // Shotgun Shell/Slug
        else if (barrel & (4|16|64)) return -1; // Spent Shell

        return -2;
    }

    override int GetFancyShellStyle(HDWeapon wpn, int state) {
        let barrel = GetChamberedRounds(wpn);

        if (barrel & 1)              return 0;  // Flare Shell
        else if (barrel & 2)         return 1;  // Shotgun Shell
        else if (barrel & (8|32))    return 2;  // Shotgun/Explosive Slug
        else if (barrel & (4|16|64)) return -1; // Spent Shell

        return -2;
    }

    override Vector2 GetChamberedRoundOffsets(HDWeapon wpn) {
        return (-1, -7);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn);
    }

    override void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        let barrel = GetChamberedRounds(wpn);

        let round = -2;

        if (barrel & 1)              round = -2; // Flare Shell
        else if (barrel & (2|8|32))  round = 0;  // Shotgun/Explosive Slug
        else if (barrel & (4|16|64)) round = -1; // Spent Shell

        let style = GetShellStyle(wpn, round);

        // If a flare is loaded and simple shells are going to be drawn,
        // just draw a full square.  Otherwise draw the vector shell
        if (style == -2) {
            sb.Fill(
                color,
                posX - (7 * scale), posY,
                7 * scale, 3 * scale,
                flags
            );
        } else {
            DrawHorzVectorShell(
                sb, wpn,
                style,
                false,
                color,
                posX, posY,
                scale,
                flags
            );
        }
    }
}
