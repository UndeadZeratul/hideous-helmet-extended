class UZTT33Override : UZPistolOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDTT33Pistol';

        magName = 'HDTokarevMag8';
        magCapacity = 8;
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'HDTokarevMag8',                                  // name
            8,                                                // capacity
            'TMG8A0', 'TMG8MPTY', 'TMG8A0', 'TMG8GREY',       // icons
            (1.0, 1.0),                                       // iconScale
            (-30, 3),                                         // offsets
            (3, -5),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }
}
