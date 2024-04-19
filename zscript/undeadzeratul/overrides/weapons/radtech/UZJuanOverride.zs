class UZJuanOverride : UZPistolOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDHorseshoePistol';

        // TODO: Fix assumption in Juan to account for loading normal 9mm Magazines
        magName = 'hdhorseshoe9m';
        magCapacity = 30;
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddMagCount(
            'hdhorseshoe9m',                                  // name
            30,                                               // capacity
            'HSMGA0', 'HSMGC0', 'HSMGA0', 'HSMGA0',           // icons
            (2.0, 2.0),                                       // iconScale
            (-30, 3),                                         // offsets
            (3, -5),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddMagCount(
            'HD9mMag15',                                      // name
            15,                                               // capacity
            'CLP2NORM', 'CLP2EMPTY', 'CLP2NORM', 'CLP2GREY',  // icons
            (1.0, 1.0),                                       // iconScale
            (-40, 3),                                         // offsets
            (3, -5),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }

    // Because Juan Magazine is scaled, DrawBar won't work.
    // Will have to fix with custom ClipRect implementation instead...
    override bool ShouldDrawFullMagazine(int value, int maxValue) {
        return value >= 1;
    }
}
