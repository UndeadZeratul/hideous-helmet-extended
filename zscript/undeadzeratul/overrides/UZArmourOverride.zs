class UZArmourOverride : HCItemOverride {
	
	override void Init(HCStatusbar sb)
	{
		Priority     = 0;
		OverrideType = HCOVERRIDETYPE_ITEM;
	}

	// Ignore all items handled in UZArmour
	override bool CheckItem(Inventory item) {
		let cls = item.GetClassName();
		return cls == "HDArmourWorn"
			|| cls == "HDCorporateArmourWorn"
			|| cls == "HHelmetWorn"
			|| cls == "HDHEVArmourWorn"
			|| cls == "HDLeatherArmourWorn"
			|| cls == "WAN_SneakingSuitWorn"
			|| cls == "WornRadBoots"
			|| cls == "WornAntiGravBoots";
	}

	override void Tick(HCStatusbar sb) {
		// No-op: Armour is handled in UZArmour
	}

	override void DrawHUDStuff(HCStatusbar sb, Inventory item, int hdFlags, int gzFlags) {
		// No-op: Armour is handled in UZArmour
	}
}
