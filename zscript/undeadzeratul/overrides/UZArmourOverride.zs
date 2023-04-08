class UZArmourOverride : HCItemOverride {
	
	override void Init(HCStatusbar sb)
	{
		Priority     = 0;
		OverrideType = HCOVERRIDETYPE_ITEM;
	}

	// Ignore all items handled in UZArmour
	override bool CheckItem(Inventory item) {
		return item is "HDArmourWorn"
			|| item is "HDCorporateArmourWorn"
			|| item is "HHelmetWorn"
			|| item is "HDHEVArmourWorn"
			|| item is "HDLeatherArmourWorn"
			|| item is "WAN_SneakingSuitWorn"
			|| item is "WornRadBoots"
			|| item is "WornAntiGravBoots";
	}

	override void Tick(HCStatusbar sb) {
		// No-op: Armour is handled in UZArmour
	}

	override void DrawHUDStuff(HCStatusbar sb, Inventory item, int state, double ticFrac) {
		// No-op: Armour is handled in UZArmour
	}
}
