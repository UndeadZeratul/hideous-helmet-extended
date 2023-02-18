class UZFullInventory : HUDElement {

	private Service _HHFunc;

	private transient CVar _enabled;
	private transient CVar _hlm_required;
	
	private transient CVar _hlm_posX;
	private transient CVar _hlm_posY;
	private transient CVar _hlm_scale;
	private transient CVar _nhm_posX;
	private transient CVar _nhm_posY;
	private transient CVar _nhm_scale;
	
	override void Init(HCStatusbar sb) {
		ZLayer = 0;
		Namespace = "fullInventory";
	}

	override void Tick(HCStatusbar sb) {
		if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

		if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_fullInventory_enabled", sb.CPlayer);
		if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_fullInventory_hlm_required", sb.CPlayer);
		if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_fullInventory_hlm_posX", sb.CPlayer);
		if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_fullInventory_hlm_posY", sb.CPlayer);
		if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_fullInventory_hlm_scale", sb.CPlayer);
		if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_fullInventory_nhm_posX", sb.CPlayer);
		if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_fullInventory_nhm_posY", sb.CPlayer);
		if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_fullInventory_nhm_scale", sb.CPlayer);
	}

	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
		bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);

		if (
			!_enabled.GetBool()
			|| (!hasHelmet && _hlm_required.GetBool())
			|| HDSpectator(sb.hpl)
		) return;

		if (CheckCommonStuff(sb, state, ticFrac) && sb.HUDLevel == 2) {
			int i = 0;
			int thisindex = -1;
		
			int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
			int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
			float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();
			
			for(inventory item = sb.cplayer.mo.inv; item != NULL; item = item.inv){
				if(!item || (!item.binvbar && item != sb.cplayer.mo.invsel)) {
					continue;
				}
				
				if(item == sb.cplayer.mo.invsel) {
					thisindex = i;
				}

				textureid icon;
				vector2   applyscale;
				
				[icon,applyscale] = sb.geticon(item, 0);
				
				int  xoffs  = (i % 5) * 20 * scale;
				int  yoffs  = (i / 5) * 20 * scale;
				bool isthis = i == thisindex;
				
				let ivsh = hdpickup(item);
				let ivsw = hdweapon(item);
				
				sb.drawtexture(
					icon,
					(posX - xoffs, posY + sb.bigitemyofs - yoffs),
					sb.DI_ITEM_CENTER_BOTTOM|sb.DI_SCREEN_RIGHT_BOTTOM
					|((
						(ivsh && ivsh.bdroptranslation)
						||(ivsw && ivsw.bdroptranslation)
					) ? sb.DI_TRANSLATABLE : 0),
					alpha:isthis ? 1. : 0.6,
					scale:applyscale * (isthis ? 1. : 0.6) * scale
				);

				i++;
			}
		}
	}
}
