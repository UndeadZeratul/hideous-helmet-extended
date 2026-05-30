class UZScopelesBossRifleOverride : UZBossRifleOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'NoScopeBoss';
    }

    override bool ShouldDrawWeaponZoom(HDWeapon wpn) {
        return false;
    }
}
