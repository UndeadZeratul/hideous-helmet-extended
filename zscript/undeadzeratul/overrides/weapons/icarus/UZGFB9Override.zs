class UZGFB9Override : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDGFBlaster';
    }

    override int GetBatteryCharge(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetBatteryCapacity(HDWeapon wpn, HDMagAmmo mag) {
        return wpn.weaponStatus[0] & 1 ? 20 : 15;
    }

    override int GetAmmoCounter(HDWeapon wpn, HDMagAmmo mag) {
        return clamp(GetBatteryCharge(wpn) % 100, 0, 50);
    }

    override int GetAmmoCounterFontColor(HDWeapon wpn, HDMagAmmo mag) {
        return Font.CR_GREEN;
    }

    override Vector2 GetAmmoCounterOffsets(HDWeapon wpn) {
        return (-2, -12);
    }

    override bool ShouldDrawBatteryCharge(HDWeapon wpn, HDMagAmmo mag) {
        return GetBatteryCharge(wpn) > 0;
    }

    override bool ShouldDrawAmmoCounter(HDWeapon wpn) {
        return true;
    }
}
