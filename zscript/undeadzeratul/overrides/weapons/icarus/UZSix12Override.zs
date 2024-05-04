class UZSix12Override : BaseWeaponStatusOverride {

    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDSix12';

        magCapacity = 6;
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'HDSix12MagShells',                               // name
            1,                                                // capacity
            'STMBA0', 'STMBB0', 'STMBA0', 'STMBB0',           // icons
            (1.25, 1.25),                                     // iconScale
            (-29, -4),                                        // offsets
            (3, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddMagCount(
            'HDSix12MagSlugs',                                // name
            1,                                                // capacity
            'STMSA0', 'STMSB0', 'STMSA0', 'STMSB0',           // icons
            (1.25, 1.25),                                     // iconScale
            (-46, -4),                                        // offsets
            (3, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetNumCylinders(HDWeapon wpn) {
        return 6;
    }


    override Color GetFullCylinderColor(HDWeapon wpn, int i) {
        return wpn.weaponStatus[2] ? Color(255, 0, 165, 215) : Color(255, 167, 0, 0);
    }

    override double GetRevolverCylinderAngle(HDWeapon wpn, int i, int numCylinders) {
        return i * (360.0 / double(numCylinders)) - 180;
    }

    override int GetCylinderRadius(HDWeapon wpn) {
        return 7;
    }

    override int GetCylinderRound(HDWeapon wpn, int i) {
        return wpn.weaponStatus[1];
    }

    override Vector2 GetRevolverCylindersOffsets(HDWeapon wpn) {
        return (-12, -15);
    }

    override Vector2 GetRevolverCylinderOffsets(HDWeapon wpn, int i, int numCylinders) {
        double angle = GetRevolverCylinderAngle(wpn, i, numCylinders);

        return (sin(angle), cos(angle));
    }

    override int GetFireModeFlags(HCStatusBar sb) {
        return sb.DI_SCREEN_CENTER_BOTTOM;
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCounts(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn, int type, WeaponStatusAmmoCounter ammoCounter, Inventory item) {
        switch (ammoCounter.name) {
            case 'HDSix12MagShells': return ammoCounter.type == type;
            case 'HDSix12MagSlugs':  return ammoCounter.type == type;
            default:                 return false;
        }
    }

    override bool ShouldDrawRevolverCylinders(HDWeapon wpn) {
        return true;
    }

    override void DrawRevolverCylinders(HCStatusBar sb, HDWeapon wpn, int numCylinders, int posX, int posY, float scale, int flags) {
        let radius = GetCylinderRadius(wpn);

        for (int i = 0; i < numCylinders; i++) {
            let cylOffs = GetRevolverCylinderOffsets(wpn, i, numCylinders) * radius;
            let round   = GetCylinderRound(wpn, i);

            if (round >= 0) {
                DrawRevolverCylinder(
                    sb, wpn,
                    (round > i)
                        ? GetFullCylinderColor(wpn, i)
                        : GetEmptyCylinderColor(wpn, i),
                    posX + (cylOffs.x < 0 ? ceil(cylOffs.x) : floor(cylOffs.x)) * scale,
                    posY + (cylOffs.y < 0 ? ceil(cylOffs.y) : floor(cylOffs.y)) * scale,
                    scale,
                    flags
                );
            }
        }
    }

    override void DrawRevolverCylinder(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        sb.fill(
            color,
            posX,
            posY,
            4 * scale, 4 * scale,
            flags
        );
    }
}
