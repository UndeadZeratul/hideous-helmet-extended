class UZSmgOverride : BaseWeaponStatusOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDSMG';
        magName = 'HD9mMag30';
        ammoName = 'HDPistolAmmo';

        magCapacity = 30;

        magIconFull = 'CLP3A0';
        magIconEmpty = 'CLP3B0';
        magIconFG = 'CLP3NORM';
        magIconBG = 'CLP3GREY';

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STBURAUT';
        fireModes[2] = 'STFULAUT';
    }

    override int GetMagRounds(HDWeapon wpn) {
        return wpn.weaponStatus[1];
    }

    override int GetFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[3];
    }

    override Vector2 GetMagazineScale(HDWeapon wpn, HDMagAmmo mag) {
        return (3.0, 3.0);
    }

    override bool ShouldDrawMagazine(HDWeapon wpn, HDMagAmmo mag) {
        return true;
    }

    override bool ShouldDrawFireMode(HDWeapon wpn) {
        return wpn.weaponStatus[5] != 1;
    }

    override bool ShouldDrawMagRounds(HDWeapon wpn, HDMagAmmo mag) {
        return GetMagRounds(wpn) > 0;
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return wpn.weaponStatus[2] == 2;
    }
}
