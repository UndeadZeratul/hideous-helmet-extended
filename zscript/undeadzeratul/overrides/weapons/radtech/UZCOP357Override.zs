class UZCOP357Override : UZRevolverOverride {

    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'COP357Pistol';
    }

    override int GetNumCylinders(HDWeapon wpn) {
        return 4;
    }

    override int GetCylinderRadius(HDWeapon wpn) {
        return 5;
    }

    override int GetCylinderRound(HDWeapon wpn, int i) {
        return wpn.weaponStatus[i];
    }

    override Vector2 GetRevolverCylindersOffsets(HDWeapon wpn) {
        return (-6, -14);
    }

    override double GetRevolverCylinderAngle(HDWeapon wpn, int i, int numCylinders) {
        return BaseWeaponStatusOverride.GetRevolverCylinderAngle(wpn, i, numCylinders);
    }

    override int GetRevolverCylinderRotation(HDWeapon wpn) {
        return -135;
    }

    override void DrawWeaponStatus(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {

        // Draw Selected Barrel under remaining status
        let i = wpn.weaponStatus[5];
        sb.Fill(
            Color(255, 255, 0, 0),
            posX + ((i == 1 || i == 4 ? -11 : -2) * scale),
            posY + ((i < 3 ? -19 : -10) * scale),
            4 * scale, 4 * scale,
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_RIGHT
        );

        super.DrawWeaponStatus(sb, wpn, posX, posY, scale, hudFont, fontColor, fontScale);        
    }
}
