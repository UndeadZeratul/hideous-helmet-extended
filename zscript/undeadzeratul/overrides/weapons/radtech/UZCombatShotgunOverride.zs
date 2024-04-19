class UZCombatShotgunOverride : UZHunterOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDCombatShotgun';
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return false;
    }

    override bool ShouldDrawSideSaddles(HDWeapon wpn) {
        return false;
    }
}
