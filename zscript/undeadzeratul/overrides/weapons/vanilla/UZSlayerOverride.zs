class UZSlayerOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'Slayer';
        ammoName = 'HDShellAmmo';

        ammoIcon = 'SHL1A0';

        fireModes[0] = 'STBURAUT';
    }

    virtual int GetLeftChamberedRound(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    virtual int GetRightChamberedRound(HDWeapon wpn) {
        return wpn.weaponStatus[2];
    }

    override int GetMagCapacity(HDWeapon wpn, HDMagAmmo mag) {
        return wpn.weaponStatus[5];
    }

    override int GetSideSaddleRounds(HDWeapon wpn) {
        return wpn.weaponStatus[3];
    }

    override int GetSideSaddleCapacity(HDWeapon wpn) {
        return 12;
    }

    override Vector2 GetAmmoOffsets() {
        return (-31, -4);
    }

    override Vector2 GetAmmoCountOffsets() {
        return (1, 2);
    }

    override Vector2 GetFireModeOffsets() {
        return (-7, -11);
    }

    override Vector2 GetChamberedRoundOffsets() {
        return (0, -3);
    }

    override Vector2 GetSideSaddleOffsets() {
        return (5, 1);
    }

    override bool ShouldDrawAmmo(HDWeapon wpn, HDAmmo ammo) {
        return true;
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 2;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetLeftChamberedRound(wpn) > 0 || GetRightChamberedRound(wpn) > 0;
    }

    override bool ShouldDrawSideSaddles(HDWeapon wpn) {
        return GetSideSaddleRounds(wpn) > 0;
    }

    override void DrawFireMode(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, int flags) {
        super.DrawFireMode(sb, wpn, posX, posY, scale, sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TRANSLATABLE);
    }

    override void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, Color color, int posX, int posY, float scale, int flags) {
        let double = ShouldDrawFireMode(wpn);
        
        let leftBarrel = GetLeftChamberedRound(wpn);
        let rightBarrel = GetRightChamberedRound(wpn);

        if (leftBarrel) {
            DrawVertVectorShell(
                sb, wpn,
                leftBarrel > 1 ? 0 : -1, Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
                posX + ((-15 + (4 * double)) * scale), posY,
                scale,
                flags
            );
        }

        if (rightBarrel) {
            DrawVertVectorShell(
                sb, wpn,
                rightBarrel > 1 ? 0 : -1, Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
                posX - ((2 + (4 * double + double)) * scale), posY,
                scale,
                flags
            );
        }
    }
}
