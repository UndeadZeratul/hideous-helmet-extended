class UZColt1911Override : UZPistolOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDColt1911';

        magName = 'HDColtMag7';
        magCapacity = 7;

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STFULAUT';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'HDColtMag7',                                     // name
            7,                                                // capacity
            'CMG7A0', 'CMG7D0', 'CMG7A0', 'CMG7C0',           // icons
            (1.0, 1.0),                                       // iconScale
            (-30, 3),                                         // offsets
            (3, -5),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }
}
