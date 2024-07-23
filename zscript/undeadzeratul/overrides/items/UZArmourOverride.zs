class UZArmourOverride : HCItemOverride {

    private transient CVar _enabled;
    
    override void Init(HCStatusbar sb) {
        Priority     = 1;
        OverrideType = HCOVERRIDETYPE_ITEM;
    }

    // Ignore all items handled in UZArmour
    override bool CheckItem(Inventory item) {
        let cls = item.GetClassName();
        return (!_enabled || _enabled.GetBool()) && (
            cls == "HDArmourWorn"
            || cls == "HDArmorPlateWorn"
            || cls == "HDCorporateArmourWorn"
            || cls == "HHelmetWorn"
            || cls == "HDHEVArmourWorn"
            || cls == "HDLeatherArmourWorn"
            || cls == "WAN_SneakingSuitWorn"
            || cls == "WornRadBoots"
            || cls == "WornRadsuit"
            || cls == "WornAntiGravBoots"
            || cls == "Despicyto"
        );
    }

    override void Tick(HCStatusbar sb) {
        if (!_enabled) _enabled = CVar.GetCVar("uz_hhx_armour_enabled", sb.CPlayer);
    }
}
