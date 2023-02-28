class UZWeaponStash : HUDWeaponStash {

	private Service _HHFunc;

	private transient CVar _enabled;
	private transient CVar _hlm_required;

	private transient CVar _hlm_hudLevel;
	private transient CVar _hlm_posX;
	private transient CVar _hlm_posY;
	private transient CVar _hlm_scale;
	private transient CVar _hlm_xScale;
	private transient CVar _hlm_yScale;
	private transient CVar _nhm_hudLevel;
	private transient CVar _nhm_posX;
	private transient CVar _nhm_posY;
	private transient CVar _nhm_scale;
	private transient CVar _nhm_xScale;
	private transient CVar _nhm_yScale;

	override void Tick(HCStatusbar sb) {
		if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

		if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_weaponStash_enabled", sb.CPlayer);
		if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_weaponStash_hlm_required", sb.CPlayer);
		if (!_hlm_hudLevel) _hlm_hudLevel = CVar.GetCVar("uz_hhx_weaponStash_hlm_hudLevel", sb.CPlayer);
		if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_weaponStash_hlm_posX", sb.CPlayer);
		if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_weaponStash_hlm_posY", sb.CPlayer);
		if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_weaponStash_hlm_scale", sb.CPlayer);
		if (!_hlm_xScale) _hlm_xScale     = CVar.GetCVar("uz_hhx_weaponStash_hlm_xScale", sb.CPlayer);
		if (!_hlm_yScale) _hlm_yScale     = CVar.GetCVar("uz_hhx_weaponStash_hlm_yScale", sb.CPlayer);
		if (!_nhm_hudLevel) _nhm_hudLevel = CVar.GetCVar("uz_hhx_weaponStash_nhm_hudLevel", sb.CPlayer);
		if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_weaponStash_nhm_posX", sb.CPlayer);
		if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_weaponStash_nhm_posY", sb.CPlayer);
		if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_weaponStash_nhm_scale", sb.CPlayer);
		if (!_nhm_xScale) _nhm_xScale     = CVar.GetCVar("uz_hhx_weaponStash_nhm_xScale", sb.CPlayer);
		if (!_nhm_yScale) _nhm_yScale     = CVar.GetCVar("uz_hhx_weaponStash_nhm_yScale", sb.CPlayer);
	}

	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
		bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);
		int  hudLevel  = hasHelmet ? _hlm_hudLevel.GetInt() : _nhm_hudLevel.GetInt();

		if (
			!_enabled.GetBool()
			|| (!hasHelmet && _hlm_required.GetBool())
			|| HDSpectator(sb.hpl)
			|| sb.HUDLevel < hudLevel
		) return;
		
		int   posX   = hasHelmet ? _hlm_posX.GetInt()     : _nhm_posX.GetInt();
		int   posY   = hasHelmet ? _hlm_posY.GetInt()     : _nhm_posY.GetInt();
		float scale  = hasHelmet ? _hlm_scale.GetFloat()  : _nhm_scale.GetFloat();
		float xScale = hasHelmet ? _hlm_xScale.GetFloat() : _nhm_xScale.GetFloat();
		float yScale = hasHelmet ? _hlm_yScale.GetFloat() : _nhm_yScale.GetFloat();

		if (AutomapActive) {
			drawWeaponStash(sb, sb.DI_SCREEN_RIGHT_BOTTOM|sb.DI_ITEM_RIGHT, -8, -48, scale, xScale, yScale);
		} else if (CheckCommonStuff(sb, state, ticFrac)) {
			drawWeaponStash(sb, sb.DI_SCREEN_LEFT_BOTTOM|sb.DI_ITEM_LEFT, posX, posY, scale, xScale, yScale);
		}
	}

	void DrawWeaponStash(HCStatusbar sb, int flags, int posX, int posY, float scale = 1., float xScale = 1., float yScale = 1.) {
		for(int i = sb.wepsprites.size() - 1; i >= 0; i--) {

			// Draw the weapon sprite itself
			sb.DrawImage(
				sb.wepSprites[i],
				(posX + (sb.wepSpriteOfs[i] * xScale), posY - (sb.wepSpriteOfs[i] * yScale)),
				flags|sb.DI_ITEM_BOTTOM,
				scale: (sb.wepSpriteScales[i] * scale, sb.wepSpriteScales[i] * scale)
			);

			// Draw the number of copies of that weapon in the player's inventory,
			// should they be carrying more than one
			int count = sb.wepSpriteCounts[i];
			if(count > 1) {
				sb.DrawString(
					sb.psmallfont,
					count.."x",
					(posX + (sb.wepSpriteOfs[i] * xScale) - (flags & sb.DI_ITEM_RIGHT ? 10 : 2), posY - (sb.wepspriteofs[i] * yScale) - 3),
					flags|sb.DI_ITEM_BOTTOM|sb.DI_TEXT_ALIGN_LEFT,
					Font.CR_DARKGRAY,
					scale: (scale, scale)
				);
			}
		}
	}
}
