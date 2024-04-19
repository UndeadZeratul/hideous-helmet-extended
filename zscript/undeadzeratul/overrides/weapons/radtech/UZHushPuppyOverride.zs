class UZHushPuppyOverride : UZPistolOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HushpuppyPistol';
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return false;
    }
}
