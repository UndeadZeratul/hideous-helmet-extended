class UZRadsuitOverride : HCItemOverride {

    private transient CVar _enabled;
    
    override void Init(HCStatusbar sb) {
        Priority     = 2;
        OverrideType = HCOVERRIDETYPE_OVERLAY;
    }

    // Ignore Radsuit to handle in UZRadsuit
    override bool CheckItem(Inventory item) {
        return (!_enabled || _enabled.GetBool()) && item.GetClassName() == "WornRadsuit";
    }

    override void Tick(HCStatusbar sb) {
        if (!_enabled) _enabled = CVar.GetCVar("uz_hhx_radsuit_enabled", sb.CPlayer);
    }
}
