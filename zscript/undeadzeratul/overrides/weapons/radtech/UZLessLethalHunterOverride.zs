class UZLessLethalHunterOverride : UZHunterOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'LLHunter';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        AddAmmoCount(
            'HDLLShellAmmo',                                  // name
            'LLS1A0',                                         // icon
            (1.0, 1.0),                                       // iconScale
            (-31, -4),                                        // offsets
            (1, 2),                                           // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }
}