class HHOverlay : HUDElement {

	private Service _HHFunc;
	
	override void Init(HCStatusbar sb) {
		ZLayer = -1;
		Namespace = "helmet";
	}

	override void Tick(HCStatusbar sb) {
		if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();
	}

	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
		bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);
		
		if (CheckCommonStuff(sb, state, ticFrac) && hasHelmet) {
			sb.DrawImage("HLMOVRLY", (0,0), sb.DI_SCREEN_CENTER_BOTTOM);
		}
	}
}
