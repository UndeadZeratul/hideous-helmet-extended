class UZHunterOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'Hunter';
        ammoName = 'HDShellAmmo';

        ammoIcon = 'SHL1A0';

        fireModes[0] = 'blank';
        fireModes[1] = 'STSEMAUT';
        fireModes[2] = 'STFULAUT';
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[4];
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

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override Vector2 GetAmmoOffsets() {
        return (-31, -4);
    }

    override Vector2 GetAmmoCountOffsets() {
        return (1, 2);
    }

    override Vector2 GetFireModeOffsets() {
        return (-10, -6);
    }

    override Vector2 GetMagazineRoundsOffsets() {
        return (0, -1);
    }

    override Vector2 GetChamberedRoundOffsets() {
        return (-2, -8);
    }

    override Vector2 GetSideSaddleOffsets() {
        return (0, 1);
    }

    override bool ShouldDrawAmmo(HDWeapon wpn, HDAmmo ammo) {
        return true;
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return !(wpn.weaponStatus[0] & 64);
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return wpn.weaponStatus[2] > 0;
    }

    override bool ShouldDrawSideSaddles(HDWeapon wpn) {
        return GetSideSaddleRounds(wpn) > 0;
    }

    override void DrawChamberedRound(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale) {
        DrawVectorShell(sb, wpn, 1, posX, posY, scale);
    }
}
