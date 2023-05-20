class UZBloodBagOverride : HCItemOverride {

	private transient CVar _enabled;

	override void Init(HCStatusbar sb) {
		Priority     = 1;
		OverrideType = HCOVERRIDETYPE_ITEM;
	}

    // Ignore Bloodbag to handle in UZBloodBagCounter
	override bool CheckItem(Inventory item) {
		return (!_enabled || _enabled.GetBool())
			&& item.GetClassName() == "BloodBagWorn";
	}

	override void DrawHUDStuff(HCStatusbar sb, Inventory item, int hdFlags, int gzFlags) {
		if (!_enabled) _enabled = CVar.GetCVar("uz_hhx_bloodBag_enabled", sb.CPlayer);
	}
}
