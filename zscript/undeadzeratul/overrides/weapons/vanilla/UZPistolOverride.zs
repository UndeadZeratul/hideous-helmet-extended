class UZPistolOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDPistol';
        magName = 'HD9mMag15';
        ammoName = 'HDPistolAmmo';

        magCapacity = 15;

        magIconFull = 'CLP2NORM';
        magIconEmpty = 'CLP2EMPTY';
        magIconFG = 'CLP2NORM';
        magIconBG = 'CLP2GREY';

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STFULAUT';
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 2;
    }

    override bool ShouldDrawMagazine(HDWeapon wpn, HDMagAmmo mag) {
        return true;
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[0] & 1;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return wpn.weaponStatus[2] == 2;
    }
}
