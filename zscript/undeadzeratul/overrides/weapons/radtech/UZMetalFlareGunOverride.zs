class UZMetalFlareGunOverride : UZFlareGunOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'MetalFireBlooper';
    }

    override void AddAmmoCounts(HCStatusBar sb) {
        super.AddAmmoCounts(sb);

        AddAmmoCount(
            'HDSlugAmmo',                                     // name
            'SLG1A0',                                         // icon
            (1.1, 1.1),                                       // iconScale
            (-37, -13),                                       // offsets
            (3, -4),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );

        AddAmmoCount(
            'HDExplosiveShellAmmo',                           // name
            'XLS1A0',                                         // icon
            (1.1, 1.1),                                       // iconScale
            (-22, -13),                                       // offsets
            (3, -4),                                          // countOffsets
            sb.DI_SCREEN_CENTER_BOTTOM,                       // iconFlags
            sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT // countFlags
        );
    }
}
