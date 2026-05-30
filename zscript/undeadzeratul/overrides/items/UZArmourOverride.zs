class UZArmourOverride : HCItemOverride {

    private transient CVar _enabled;

    private transient Array<name> armourClasses;
    
    override void Init(HCStatusbar sb) {
        Priority     = 1;
        OverrideType = HCOVERRIDETYPE_ITEM;

        armourClasses.push('HDArmourWorn');
        armourClasses.push('HDArmorPlateWorn');
        // armourClasses.push('HDCorporateArmourWorn');
        armourClasses.push('HHelmetWorn');
        // armourClasses.push('HDHEVArmourWorn');
        // armourClasses.push('HDLeatherArmourWorn');
        // armourClasses.push('WAN_SneakingSuitWorn');
        armourClasses.push('WornRadBoots');
        armourClasses.push('WornRadsuit');
        armourClasses.push('WornAntiGravBoots');
        armourClasses.push('Despicyto');
    }

    // Ignore all items handled in UZArmour
    override bool CheckItem(Inventory item) {
        return (!_enabled || _enabled.GetBool()) && HDCore.isAnyChildClass(item.getClassName(), armourClasses);
    }

    override void Tick(HCStatusbar sb) {
        if (!_enabled) _enabled = CVar.GetCVar("uz_hhx_armour_enabled", sb.CPlayer);
    }
}
