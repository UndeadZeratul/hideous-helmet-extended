class UZBloodBagOverride : HCItemOverride {

	override void Init(HCStatusbar sb) {
		Priority     = 1;
		OverrideType = HCOVERRIDETYPE_ITEM;
	}

    // Ignore Bloodbag to handle in UZBloodBagCounter
	override bool CheckItem(Inventory item) {
		return item.GetClassName() == "BloodBagWorn";
	}

	override void Tick(HCStatusbar sb) {
        // No-op: Blood Bag is handled in UZBloodBagCounter
	}

	override void DrawHUDStuff(HCStatusbar sb, Inventory item, int hdFlags, int gzFlags) {
        // No-op: Blood Bag is handled in UZBloodBagCounter
	}
}
