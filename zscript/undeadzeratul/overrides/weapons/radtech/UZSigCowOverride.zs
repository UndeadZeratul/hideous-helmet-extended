class UZSigCowOverride : UZSMGOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDDSigCow';

        magName = 'HD10mMag25';
        magCapacity = 25;

        fireModes[0] = 'STSEMAUT';
        fireModes[1] = 'STBURAUT';
        fireModes[2] = 'STFULAUT';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'HD10mMag8',                                      // name
            25,                                               // capacity
            'C10MA0', 'C10MD0', 'C10MA0', 'C10MC0',           // icons
            (1.0, 1.0),                                       // iconScale
            (-30, 3),                                         // offsets
            (3, -5),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }
}
