class UZRadsuitOverride : HCItemOverride {
	
	override void Init(HCStatusbar sb) {
		Priority     = 2;
		OverrideType = HCOVERRIDETYPE_OVERLAY;
	}

	// Ignore Radsuit to handle in UZRadsuit
	override bool CheckItem(Inventory item) {
		return item.GetClassName() == "WornRadsuit";
	}

	override void Tick(HCStatusbar sb) {
        // No-op: Radsuit is handled in UZRadsuit
	}

	override void DrawHUDStuff(HCStatusbar sb, Inventory item, int hdFlags, int gzFlags) {
        // No-op: Radsuit is handled in UZRadsuit
	}
}
