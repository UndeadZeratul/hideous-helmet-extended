class UZRevolverOverride : BaseWeaponStatusOverride {

    private transient CVar _aspectScale;
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDRevolver';

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STFULAUT';

        AddAmmoCount(
            'HDRevolverAmmo',                                 // name
            '3RNDA0',                                         // icon
            (2.1, 2.55),                                      // iconScale
            (-31, -4),                                        // offsets
            (3, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddAmmoCount(
            'HDPistolAmmo',                                   // name
            'PRNDA0',                                         // icon
            (2.1, 2.1),                                       // iconScale
            (-48, -4),                                        // offsets
            (4, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override void InitCvars(HCStatusBar sb) {
        super.InitCvars(sb);
        
        if (!_aspectScale) _aspectScale = CVar.GetCVar('hud_aspectscale', sb.CPlayer);
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetNumCylinders(HDWeapon wpn) {
        return 6;
    }

    override int GetCylinderRadius(HDWeapon wpn) {
        return 5;
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 2;
    }

    override Vector2 GetRevolverCylindersOffsets(HDWeapon wpn) {
        Vector2 baseOffs = super.GetRevolverCylindersOffsets(wpn);

        int plf = wpn.owner && wpn.owner.player ? wpn.owner.player.GetPSprite(PSP_WEAPON).frame : 0;
        if (plf == 4) {
            return baseOffs + (-8, 6);
        } else if (plf ==5 || plf == 6) {
            return baseOffs + (-12, 8);
        } else {
            return baseOffs;
        }
    }

    override double GetRevolverCylinderAngle(HDWeapon wpn, int i, int numCylinders) {
        double baseAngle = super.GetRevolverCylinderAngle(wpn, i, numCylinders);

        int plf = wpn.owner && wpn.owner.player ? wpn.owner.player.GetPSprite(PSP_WEAPON).frame : 0;
        if (plf == 4) {
            return baseAngle - 45.0;
        } else if (plf ==5 || plf == 6) {
            return baseAngle - 90.0;
        } else {
            return baseAngle;
        }
    }

    override Vector2 GetRevolverCylinderOffsets(HDWeapon wpn, int i, int numCylinders) {
        double angle = GetRevolverCylinderAngle(wpn, i, numCylinders);

        double cdrngl = cos(angle);
        double sdrngl = sin(angle);

        int plf = wpn.owner && wpn.owner.player ? wpn.owner.player.GetPSprite(PSP_WEAPON).frame : 0;
        if (!(plf ==5 || plf == 6) && _aspectScale && _aspectScale.getbool()) {
            cdrngl *= 1.1;
            sdrngl *= (1.0 / 1.1);
        }

        return (cdrngl, sdrngl) * GetCylinderRadius(wpn);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, bool isMag, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HDRevolverAmmo': return ammoCounter.isMag == isMag;
            case 'HDPistolAmmo':   return ammoCounter.isMag == isMag && !!item;
            default:               return false;
        }
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 1;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return wpn.weaponStatus[2] == 2;
    }

    override bool ShouldDrawRevolverCylinders(HDWeapon wpn) {
        return true;
    }
}
