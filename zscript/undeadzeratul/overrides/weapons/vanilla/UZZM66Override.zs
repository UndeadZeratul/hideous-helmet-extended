class UZZM66Override : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'ZM66AssaultRifle';
        magName = 'HD4mMag';
        ammoName = 'HDRocketAmmo';

        magCapacity = 50;

        magIconFull = 'ZMAGA0';
        magIconEmpty = 'ZMAGC0';
        magIconFG = 'ZMAGNORM';
        magIconBG = 'ZMAGGREY';

        ammoIcon = 'ROQPA0';

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STFULAUT';
        fireModes[2] = 'STBURAUT';
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetAmmoCount(HDWeapon wpn, HDMagAmmo mag) {

        // Coerce the magazine value into the size of the 4mm Mag
        int count = clamp(GetMagRounds(wpn) % 100, 0, magCapacity);

        // If we have a round in the chamber, add one more.
        if (ShouldDrawChamberedRound(wpn)) count++;

        // If the magazine that's inserted is dirty, randomize the counter value
        return GetMagRounds(wpn) > 100 ? random[shitgun](10,99) : count;
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[2];
    }

    override int GetWeaponZoom(HDWeapon wpn) {
        return wpn.weaponStatus[3];
    }

    override Vector2 GetAmmoOffsets() {
        return (-46, 2);
    }

    override Vector2 GetMagazineScale(HDWeapon wpn, HDMagAmmo mag) {
        return (2.0, 2.0);
    }

    override Vector2 GetAmmoScale(HDWeapon wpn, HDAmmo ammo) {
        return (0.6, 0.6);
    }

    override Vector2 GetChamberedRoundOffsets() {
        return (-3, -4);
    }

    virtual Vector2 GetChamberedGrenadeOffsets() {
        return (-4, -8);
    }

    override bool ShouldDrawMagazine(HDWeapon wpn, HDMagAmmo mag) {
        return true;
    }

    override bool ShouldDrawFullMagazine(int value, int maxValue) {
        return value > magCapacity;
    }

    override bool ShouldDrawAmmo(HDWeapon wpn, HDAmmo ammo) {
        return !(wpn.weaponStatus[0] & 16);
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return !(wpn.weaponStatus[0] & 32);
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawAmmoCount(HDWeapon wpn) {
        return true;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 1;
    }

    virtual bool ShouldDrawChamberedGrenade(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 8;
    }

    override bool ShouldDrawRangeFinder(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 64;
    }

    override bool ShouldDrawWeaponZoom(HDWeapon wpn) {
        return !ShouldDrawRangeFinder(wpn) && wpn.weaponStatus[3];
    }

    override void DrawWeaponStatus(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        super.DrawWeaponStatus(sb, wpn, posX, posY, scale, hudFont, fontColor, fontScale);
                
        let mag = GetMagazine(sb.hpl.FindInventory(magName));

        if (ShouldDrawChamberedGrenade(wpn)) {
            let offs = GetChamberedGrenadeOffsets();
            DrawChamberedGrenade(sb, wpn, posX + (offs.x * scale), posY + (offs.y * scale), scale);
        }
    }

    virtual void DrawChamberedGrenade(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale) {
        sb.DrawRect(posX, posY, 4 * scale, 2.6 * scale);
    }
}
