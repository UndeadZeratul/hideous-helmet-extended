class UZBarracudaOverride : BaseWeaponStatusOverride {

    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDBarracuda';

        magCapacity = 6;

        fireModes[0] = 'blank';
        fireModes[1] = 'STBURAUT';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'HDSix12MagShells',                               // name
            1,                                                // capacity
            'STMBA0', 'STMBB0', 'STMBA0', 'STMBB0',           // icons
            (1.25, 1.25),                                     // iconScale
            (-11, -4),                                        // offsets
            (3, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddMagCount(
            'HDSix12MagSlugs',                                // name
            1,                                                // capacity
            'STMSA0', 'STMSB0', 'STMSA0', 'STMSB0',           // icons
            (1.25, 1.25),                                     // iconScale
            (-31, -4),                                        // offsets
            (3, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    override int GetNumCylinders(HDWeapon wpn) {
        // 0-5 == side=0, 6-12 == side=1
        return 12;
    }

    virtual bool GetCylinderSide(HDweapon wpn, int i, int numCylinders) {
        // 0..11 / (12 / 2) -> 0..11 / 6 -> 0..1
        return i / (numCylinders / 2);
    }

    override Color GetFullCylinderColor(HDWeapon wpn, int i) {
        return wpn.weaponStatus[3] & (1 << GetCylinderSide(wpn, i, GetNumCylinders(wpn))) ? Color(255, 0, 165, 215) : Color(255, 167, 0, 0);
    }

    override double GetRevolverCylinderAngle(HDWeapon wpn, int i, int numCylinders) {
        return i * (360.0 / double(numCylinders / 2));
    }

    override int GetCylinderRadius(HDWeapon wpn) {
        return 7;
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 2;
    }

    override int GetCylinderRound(HDWeapon wpn, int i) {
        return wpn.weaponStatus[1 + GetCylinderSide(wpn, i, GetNumCylinders(wpn))];
    }

    override Vector2 GetFireModeOffsets(HDWeapon wpn) {
        return (-20, -31);
    }

    override Vector2 GetRevolverCylindersOffsets(HDWeapon wpn) {
        return (-32, -29);
    }

    override Vector2 GetRevolverCylinderOffsets(HDWeapon wpn, int i, int numCylinders) {
        double angle = GetRevolverCylinderAngle(wpn, i % (numCylinders / 2), numCylinders) + (!GetCylinderSide(wpn, i, numCylinders) ? 90 : -30);

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
            let side    = GetCylinderSide(wpn, i, numCylinders);

            if (round >= 0) {
                DrawRevolverCylinder(
                    sb, wpn,
                    (!side ? round > i : round >= (numCylinders - i))
                        ? GetFullCylinderColor(wpn, i)
                        : GetEmptyCylinderColor(wpn, i),
                    posX + (20 * side * scale) + (cylOffs.x < 0 ? ceil(cylOffs.x) : floor(cylOffs.x)) * scale,
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
