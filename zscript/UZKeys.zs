class UZKeys : HUDKeys {

	private Service _HHFunc;

	private transient CVar _enabled;
	private transient CVar _hlm_required;

	private transient CVar _hlm_posX;
	private transient CVar _hlm_posY;
	private transient CVar _hlm_scale;
	private transient CVar _nhm_posX;
	private transient CVar _nhm_posY;
	private transient CVar _nhm_scale;

	override void Tick(HCStatusbar sb) {
		if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

		if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_keys_enabled", sb.CPlayer);
		if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_keys_hlm_required", sb.CPlayer);
		if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_keys_hlm_posX", sb.CPlayer);
		if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_keys_hlm_posY", sb.CPlayer);
		if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_keys_hlm_scale", sb.CPlayer);
		if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_keys_nhm_posX", sb.CPlayer);
		if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_keys_nhm_posY", sb.CPlayer);
		if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_keys_nhm_scale", sb.CPlayer);
	}

	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
		bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);

		if (
			!_enabled.GetBool()
			|| (!hasHelmet && _hlm_required.GetBool())
			|| HDSpectator(sb.hpl)
		) return;

		if (AutomapActive) {
			if(sb.hpl.countinv("BlueCard"))    sb.drawimage("BKEYB0", (10,24), sb.DI_TOPLEFT);
			if(sb.hpl.countinv("YellowCard"))  sb.drawimage("YKEYB0", (10,44), sb.DI_TOPLEFT);
			if(sb.hpl.countinv("RedCard"))     sb.drawimage("RKEYB0", (10,64), sb.DI_TOPLEFT);
			if(sb.hpl.countinv("BlueSkull"))   sb.drawimage("BSKUA0", (6,30),  sb.DI_TOPLEFT);
			if(sb.hpl.countinv("YellowSkull")) sb.drawimage("YSKUA0", (6,50),  sb.DI_TOPLEFT);
			if(sb.hpl.countinv("RedSkull"))    sb.drawimage("RSKUB0", (6,70),  sb.DI_TOPLEFT);
		} else if (CheckCommonStuff(sb, state, ticFrac)) {
		
			int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
			int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
			float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();
		
			// Blue Key(s)
			string keytype="";
			if(sb.hpl.countinv("BlueCard"))  keytype = "STKEYS0";
			if(sb.hpl.countinv("BlueSkull")) keytype = keyType == "" ? "STKEYS3" : "STKEYS6";
			if(keytype!="")sb.drawimage(
				keytype,
				(posX, posY - (12 * scale)),
				sb.DI_SCREEN_CENTER_BOTTOM,
				scale: (scale, scale)
			);
			
			// Yellow Key(s)
			keytype="";
			if(sb.hpl.countinv("YellowCard"))  keytype = "STKEYS1";
			if(sb.hpl.countinv("YellowSkull")) keytype = keytype == "" ? "STKEYS4" : "STKEYS7";
			if(keytype!="")sb.drawimage(
				keytype,
				(posX, posY - (6 * scale)),
				sb.DI_SCREEN_CENTER_BOTTOM,
				scale: (scale, scale)
			);
			
			// Red Key(s)
			keytype="";
			if(sb.hpl.countinv("RedCard"))  keytype = "STKEYS2";
			if(sb.hpl.countinv("RedSkull")) keytype = keytype == "" ? "STKEYS5" : "STKEYS8";
			if(keytype!="")sb.drawimage(
				keytype,
				(posX , posY),
				sb.DI_SCREEN_CENTER_BOTTOM,
				scale: (scale, scale)
			);
		}
	}
}
