class UZ10mmPistolOverride : UZPistolOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HD10mmPistol';

        magName = 'HD10mMag8';
        magCapacity = 8;

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STFULAUT';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'HD10mMag8',                                      // name
            8,                                                // capacity
            'SC15A0', 'SC15D0', 'SC15A0', 'SC15C0',           // icons
            (1.0, 1.0),                                       // iconScale
            (-30, 3),                                         // offsets
            (3, -5),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }
}
