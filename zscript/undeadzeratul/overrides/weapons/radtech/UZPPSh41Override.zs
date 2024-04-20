class UZPPSh41Override : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDPPSh41';

        magCapacity = 35;

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STFULAUT';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'HDTokarevMag71',                                 // name
            71,                                               // capacity
            'PSDMA0', 'PSDMD0', 'PSDMA0', 'PSDMC0',           // icons
            (1.0, 1.0),                                       // iconScale
            (-34, 3),                                         // offsets
            (7, -5),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddMagCount(
            'HDTokarevMag35',                                 // name
            35,                                               // capacity
            'PSHMA0', 'PSHMD0', 'PSHMA0', 'PSHMC0',           // icons
            (1.0, 1.0),                                       // iconScale
            (-47, 3),                                         // offsets
            (7, -5),                                          // countOffsets
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

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 2;
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        return ammoCounter.type == type;
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn) > 0;
    }

    override void DrawMagazineRounds(HCStatusBar sb, HDWeapon wpn, int value, int maxValue, bool precise, Color color, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale, int flags) {
        super.DrawMagazineRounds(sb, wpn, value, value > magCapacity ? value : magCapacity, precise, color, posX, posY, scale, hudFont, fontColor, fontScale, flags);

        if (value > magCapacity) {
            super.DrawMagazineRounds(sb, wpn, value - magCapacity, magCapacity, precise, color, posX, posY + (4 * scale), scale, hudFont, fontColor, fontScale, flags);
        }
    }
}
