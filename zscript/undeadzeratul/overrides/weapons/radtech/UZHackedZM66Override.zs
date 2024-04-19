class UZHackedZM66Override : UZZM66Override {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HackedZM66AssaultRifle';

        fireModes[2] = 'STQBURST';
    }

    override bool ShouldDrawAmmoCounter(HDWeapon wpn) {
        return false;
    }
}
