class UZEncumbrance : HUDEncumbrance {

	private Service _HHFunc;
	
	private transient CVar _hlm_posX;
	private transient CVar _hlm_posY;
	private transient CVar _hlm_scale;
	private transient CVar _nhm_posX;
	private transient CVar _nhm_posY;
	private transient CVar _nhm_scale;

	override void Tick(HCStatusbar sb) {
		if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

		if (!_hlm_posX) _hlm_posX   = CVar.GetCVar("uz_hhx_encumbrance_hlm_posX", sb.CPlayer);
		if (!_hlm_posY) _hlm_posY   = CVar.GetCVar("uz_hhx_encumbrance_hlm_posY", sb.CPlayer);
		if (!_hlm_scale) _hlm_scale = CVar.GetCVar("uz_hhx_encumbrance_hlm_scale", sb.CPlayer);	
		if (!_nhm_posX) _nhm_posX   = CVar.GetCVar("uz_hhx_encumbrance_nhm_posX", sb.CPlayer);
		if (!_nhm_posY) _nhm_posY   = CVar.GetCVar("uz_hhx_encumbrance_nhm_posY", sb.CPlayer);
		if (!_nhm_scale) _nhm_scale = CVar.GetCVar("uz_hhx_encumbrance_nhm_scale", sb.CPlayer);
	}

	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
		if (HDSpectator(sb.hpl))
			return;

		if (CheckCommonStuff(sb, state, ticFrac) && sb.HUDLevel == 2) {
			bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);

			int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
			int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
			float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();

			//encumbrance
			if(sb.hpl.enc){
				double pocketenc = sb.hpl.pocketenc;

				sb.drawstring(
					sb.pnewsmallfont,
					sb.FormatNumber(int(sb.hpl.enc)),
					(posX + 4, posY + sb.mxht),
					sb.DI_TEXT_ALIGN_LEFT|sb.DI_SCREEN_LEFT_BOTTOM,
					sb.hpl.overloaded < 0.8
						? Font.CR_OLIVE 
						: sb.hpl.overloaded > 1.6
							? Font.CR_RED
							: Font.CR_GOLD,
					scale: (0.5 * scale, 0.5 * scale)
				);

				int encbarheight = sb.mxht + 5;

				// Encumbrance Bar Border
				sb.fill(
					color(128,96,96,96),
					posX,
					posY + encbarheight,
					scale,
					-scale,
					sb.DI_SCREEN_LEFT_BOTTOM|sb.DI_ITEM_LEFT
				);
				sb.fill(
					color(128,96,96,96),
					posX + 1,
					posY + encbarheight,
					scale,
					-20 * scale,
					sb.DI_SCREEN_LEFT_BOTTOM|sb.DI_ITEM_LEFT
				);
				sb.fill(
					color(128,96,96,96),
					posX - 1,
					posY + encbarheight,
					scale,
					-20 * scale,
					sb.DI_SCREEN_LEFT_BOTTOM|sb.DI_ITEM_LEFT
				);

				encbarheight--;

				// Encumbrance Bar Fill
				sb.drawrect(
					posX,
					posY + encbarheight,
					scale,
					(-min(sb.hpl.maxpocketspace, pocketenc) * 19 / sb.hpl.maxpocketspace) * scale,
					sb.DI_SCREEN_LEFT_BOTTOM|sb.DI_ITEM_LEFT
				);

				// Over-Encumbrance Bar Fill
				bool overenc = sb.hpl.flip && pocketenc > sb.hpl.maxpocketspace;

				sb.fill(
					overenc ? color(255,216,194,42) : color(128,96,96,96),
					posX,
					posY + encbarheight - (19 * scale),
					scale,
					overenc ? 3 * scale : scale,
					sb.DI_SCREEN_LEFT_BOTTOM|sb.DI_ITEM_LEFT
				);
			}
		}
	}
}
