// UNUSED UNTIL PROPERLY EXTENDABLE
class UZWeaponStatus : HHWeaponStatus {

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
		if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_weaponStatus_hlm_required", sb.CPlayer);
		if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_weaponStatus_hlm_posX", sb.CPlayer);
		if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_weaponStatus_hlm_posY", sb.CPlayer);
		if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_weaponStatus_hlm_scale", sb.CPlayer);
		if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_weaponStatus_nhm_posX", sb.CPlayer);
		if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_weaponStatus_nhm_posY", sb.CPlayer);
		if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_weaponStatus_nhm_scale", sb.CPlayer);
	}

	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
		bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);
		
		if (
			!_enabled.GetBool()
			|| (!hasHelmet && _hlm_required.GetBool())
			|| !HDWeapon(sb.CPlayer.ReadyWeapon)
			|| HDSpectator(sb.hpl)
		) return;

		if (_HHFunc && _HHFunc.GetIntUI("CheckWeaponStuff", objectArg: sb)
			&& CheckCommonStuff(sb, state, ticFrac)
			&& sb.cplayer.readyweapon && sb.cplayer.readyweapon != WP_NOCHANGE) {
			
			let hdw = hdweapon(sb.cplayer.readyweapon);
			if(hdw) {
				hdw.DrawHUDStuff(sb, hdw, sb.hpl);
			} else {
				int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
				int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
				float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();
	
				if(sb.cplayer.readyweapon.ammotype1) {
					sb.drawwepnum(
						sb.hpl.countinv(sb.cplayer.readyweapon.ammotype1),
						getdefaultbytype(sb.cplayer.readyweapon.ammotype1).maxamount,
						posX,
						posY
					);
				}

				if(sb.cplayer.readyweapon.ammotype2) {
					sb.drawwepnum(
						sb.hpl.countinv(sb.cplayer.readyweapon.ammotype2),
						getdefaultbytype(sb.cplayer.readyweapon.ammotype2).maxamount,
						posX,
						posY - 4
					);
				}
			}
		} else if (!_hh_hidefiremode.GetBool()) {
			_HHFunc.GetIntUI("GetWeaponFiremode", objectArg: sb);
		}
	}
}
