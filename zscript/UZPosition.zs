class UZPosition : HHPosition {

	private Service _HHFunc;
	
	private transient CVar _hh_hidecompass;

	private transient CVar _hlm_posX;
	private transient CVar _hlm_posY;
	private transient CVar _hlm_scale;
	private transient CVar _nhm_posX;
	private transient CVar _nhm_posY;
	private transient CVar _nhm_scale;

	override void Tick(HCStatusbar sb) {
		if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

		if (!_hh_hidecompass) _hh_hidecompass = CVar.GetCVar("hh_hidecompass", sb.CPlayer);

		if (!_hlm_posX) _hlm_posX   = CVar.GetCVar("uz_hhx_compass_hlm_posX", sb.CPlayer);
		if (!_hlm_posY) _hlm_posY   = CVar.GetCVar("uz_hhx_compass_hlm_posY", sb.CPlayer);
		if (!_hlm_scale) _hlm_scale = CVar.GetCVar("uz_hhx_compass_hlm_scale", sb.CPlayer);
		if (!_nhm_posX) _nhm_posX   = CVar.GetCVar("uz_hhx_compass_nhm_posX", sb.CPlayer);
		if (!_nhm_posY) _nhm_posY   = CVar.GetCVar("uz_hhx_compass_nhm_posY", sb.CPlayer);
		if (!_nhm_scale) _nhm_scale = CVar.GetCVar("uz_hhx_compass_nhm_scale", sb.CPlayer);
	}

	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
		bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);

		if (!hasHelmet && _hh_hidecompass.GetBool())
			return;
		if (HDSpectator(sb.hpl))
			return;
		if (CheckCommonStuff(sb, state, ticFrac) && sb.HUDLevel == 2) {
			int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
			int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
			float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();
			
			int wephelpheight = NewSmallFont.GetHeight() * 6;
			
			string postxt = string.format("%i,%i,%i", sb.hpl.pos.x, sb.hpl.pos.y, sb.hpl.pos.z);
			screen.drawText(NewSmallFont,
				font.CR_OLIVE,
				posX - (NewSmallFont.StringWidth(postxt) >> 1),
				posY + wephelpheight + 6,
				postxt,
				DTA_VirtualWidth,640,DTA_VirtualHeight,480,DTA_ScaleX,scale,DTA_ScaleY,scale
			);
		}
	}
}
