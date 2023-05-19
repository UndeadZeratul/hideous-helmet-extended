class UZDrawHelmet : HUDElement {

	override void Init(HCStatusbar sb) {
		ZLayer = 0;
		Namespace = "HHDrawHelmet";
	}

	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
        // no-op: Helmet handled in UZArmour
    }
}