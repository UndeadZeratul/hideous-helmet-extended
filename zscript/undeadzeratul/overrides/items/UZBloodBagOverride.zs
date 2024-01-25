class UZBloodBagOverride : HCItemOverride {

    private transient CVar _enabled;

    override void Init(HCStatusbar sb) {
        Priority     = 1;
        OverrideType = HCOVERRIDETYPE_ITEM;
    }

    // Ignore Bloodbag to handle in UZBloodBagCounter
    override bool CheckItem(Inventory item) {
        return (!_enabled || _enabled.GetBool()) && item.GetClassName() == "BloodBagWorn";
    }

    override void Tick(HCStatusbar sb) {
        if (!_enabled) _enabled = CVar.GetCVar("uz_hhx_bloodBagCounter_enabled", sb.CPlayer);
    }
}
