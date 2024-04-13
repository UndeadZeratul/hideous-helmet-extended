class UZRevolverOverride : BaseWeaponStatusOverride {

    private transient CVar _aspectScale;
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDRevolver';
    }

    override void InitCvars(HCStatusBar sb) {
        super.InitCvars(sb);
        
        if (!_aspectScale) _aspectScale = CVar.GetCVar('hud_aspectscale', sb.CPlayer);
    }

    override void AddAmmoCounts(HCStatusBar sb) {
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

    override int GetNumCylinders(HDWeapon wpn) {
        return 6;
    }

    override int GetCylinderRadius(HDWeapon wpn) {
        return 5;
    }

    override int GetCylinderRound(HDWeapon wpn, int i) {
        return wpn.weaponStatus[i];
    }

    virtual bool IsCylinderOpen(HDWeapon wpn) {
        int plf = (wpn.owner && wpn.owner.player) ? wpn.owner.player.GetPSprite(PSP_WEAPON).frame : 0;
        return (plf == 4 || plf == 5 || plf == 6 || HDPlayerPawn(wpn.owner).wepHelpText.IndexOf(StringTable.Localize('$REVCWH_FIRE')) >= 0);
    }

    override Vector2 GetRevolverCylindersOffsets(HDWeapon wpn) {
        if (wpn.owner && wpn.owner.player && wpn.owner.player.GetPSprite(PSP_WEAPON).frame == 4) {
            return (-14, -8);
        } else if (IsCylinderOpen(wpn)) {
            return (-18, -6);
        } else {
            return (-6, -14);
        }
    }

    override double GetRevolverCylinderAngle(HDWeapon wpn, int i, int numCylinders) {
        double baseAngle = super.GetRevolverCylinderAngle(wpn, i, numCylinders);

        if (wpn.owner && wpn.owner.player && wpn.owner.player.GetPSprite(PSP_WEAPON).frame == 4) {
            return baseAngle - 45.0;
        } else if (IsCylinderOpen(wpn)) {
            return baseAngle - 90.0;
        } else {
            return baseAngle;
        }
    }

    override Vector2 GetRevolverCylinderOffsets(HDWeapon wpn, int i, int numCylinders) {
        double angle = GetRevolverCylinderAngle(wpn, i, numCylinders);

        double cdrngl = cos(angle);
        double sdrngl = sin(angle);

        if (!IsCylinderOpen(wpn) && _aspectScale && _aspectScale.getbool()) {
            cdrngl *= 1.1;
            sdrngl *= (1.0 / 1.1);
        }

        return (cdrngl, sdrngl);
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HDRevolverAmmo': return ammoCounter.type == type;
            case 'HDPistolAmmo':   return ammoCounter.type == type && !!item;
            default:               return false;
        }
    }

    override bool ShouldDrawRevolverCylinders(HDWeapon wpn) {
        return true;
    }
}
