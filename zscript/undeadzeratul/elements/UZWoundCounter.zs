class UZWoundCounter : HUDElement {

	private Service _HHFunc;

	private transient CVar _enabled;
	private transient CVar _hlm_required;
	
	private transient CVar _hh_showbleed;
	private transient CVar _hh_showbleedwhenbleeding;
	private transient CVar _hh_woundcounter;
	private transient CVar _hh_onlyshowopenwounds;
	private transient CVar _hh_wc_usedynamiccol;
	
	private string _WoundCounter;
	
	private transient CVar _hlm_hudLevel;
	private transient CVar _hlm_posX;
	private transient CVar _hlm_posY;
	private transient CVar _hlm_scale;
	private transient CVar _nhm_hudLevel;
	private transient CVar _nhm_posX;
	private transient CVar _nhm_posY;
	private transient CVar _nhm_scale;

	private transient CVar _nhm_bgRef;
	private transient CVar _nhm_bgPosX;
	private transient CVar _nhm_bgPosY;
	private transient CVar _nhm_bgScale;
	private transient CVar _hlm_bgRef;
	private transient CVar _hlm_bgPosX;
	private transient CVar _hlm_bgPosY;
	private transient CVar _hlm_bgScale;

	override void Init(HCStatusbar sb) {
		ZLayer    = 2;
		Namespace = "woundcounter";
	}

	override void Tick(HCStatusbar sb) {
		if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

		if (!_hh_showbleed) _hh_showbleed                         = CVar.GetCVar("hh_showbleed", sb.CPlayer);
		if (!_hh_showbleedwhenbleeding) _hh_showbleedwhenbleeding = CVar.GetCVar("hh_showbleedwhenbleeding", sb.CPlayer);
		if (!_hh_woundcounter) _hh_woundcounter                   = CVar.GetCVar("hh_woundcounter", sb.CPlayer);
		if (!_hh_onlyshowopenwounds) _hh_onlyshowopenwounds       = CVar.GetCVar("hh_onlyshowopenwounds", sb.CPlayer);
		if (!_hh_wc_usedynamiccol) _hh_wc_usedynamiccol           = CVar.GetCVar("hh_wc_usedynamiccol", sb.CPlayer);
			
		if (!_enabled) _enabled                                   = CVar.GetCVar("uz_hhx_woundCounter_enabled", sb.CPlayer);
		if (!_hlm_required) _hlm_required                         = CVar.GetCVar("uz_hhx_woundCounter_hlm_required", sb.CPlayer);
		if (!_hlm_hudLevel) _hlm_hudLevel                         = CVar.GetCVar("uz_hhx_woundCounter_hlm_hudLevel", sb.CPlayer);
		if (!_hlm_posX) _hlm_posX                                 = CVar.GetCVar("uz_hhx_woundCounter_hlm_posX", sb.CPlayer);
		if (!_hlm_posY) _hlm_posY                                 = CVar.GetCVar("uz_hhx_woundCounter_hlm_posY", sb.CPlayer);
		if (!_hlm_scale) _hlm_scale                               = CVar.GetCVar("uz_hhx_woundCounter_hlm_scale", sb.CPlayer);
		if (!_nhm_hudLevel) _nhm_hudLevel                         = CVar.GetCVar("uz_hhx_woundCounter_nhm_hudLevel", sb.CPlayer);
		if (!_nhm_posX) _nhm_posX                                 = CVar.GetCVar("uz_hhx_woundCounter_nhm_posX", sb.CPlayer);
		if (!_nhm_posY) _nhm_posY                                 = CVar.GetCVar("uz_hhx_woundCounter_nhm_posY", sb.CPlayer);
		if (!_nhm_scale) _nhm_scale                               = CVar.GetCVar("uz_hhx_woundCounter_nhm_scale", sb.CPlayer);

		if (!_nhm_bgRef) _nhm_bgRef                               = CVar.GetCVar("uz_hhx_woundCounter_bg_nhm_ref", sb.CPlayer);
		if (!_nhm_bgPosX) _nhm_bgPosX                             = CVar.GetCVar("uz_hhx_woundCounter_bg_nhm_posX", sb.CPlayer);
		if (!_nhm_bgPosY) _nhm_bgPosY                             = CVar.GetCVar("uz_hhx_woundCounter_bg_nhm_posY", sb.CPlayer);
		if (!_nhm_bgScale) _nhm_bgScale                           = CVar.GetCVar("uz_hhx_woundCounter_bg_nhm_scale", sb.CPlayer);
		if (!_hlm_bgRef) _hlm_bgRef                               = CVar.GetCVar("uz_hhx_woundCounter_bg_hlm_ref", sb.CPlayer);
		if (!_hlm_bgPosX) _hlm_bgPosX                             = CVar.GetCVar("uz_hhx_woundCounter_bg_hlm_posX", sb.CPlayer);
		if (!_hlm_bgPosY) _hlm_bgPosY                             = CVar.GetCVar("uz_hhx_woundCounter_bg_hlm_posY", sb.CPlayer);
		if (!_hlm_bgScale) _hlm_bgScale                           = CVar.GetCVar("uz_hhx_woundCounter_bg_hlm_scale", sb.CPlayer);

		if (!sb.hpl)
			return;

		int openWounds = 0;
		int patchedWounds = 0;
		int sealedWounds = 0;
		let ti = ThinkerIterator.Create("HDBleedingWound", Thinker.STAT_DEFAULT);
		HDBleedingWound wound;
		while (wound = HDBleedingWound(ti.Next())) {
			if (wound.Bleeder != sb.hpl)
				continue;

			if (wound.Depth == 0 && wound.Patched == 0) {
				++sealedWounds;
			} else if (wound.Depth == 0) {
				++patchedWounds;
			} else {
				++openWounds;
			}
		}

		_WoundCounter = "";
		if (openWounds > 0) {
			_WoundCounter = string.Format("\c[Red]%s \c-", sb.FormatNumber(openWounds, 3));
		}

		if (patchedWounds > 0 && !_hh_onlyshowopenwounds.GetBool()) {
			_WoundCounter = string.Format("%s\c[Fire]%s \c-", _WoundCounter, sb.FormatNumber(patchedWounds, 3));
		}

		if (sealedWounds > 0 && !_hh_onlyshowopenwounds.GetBool()) {
			_WoundCounter = string.Format("%s\c[Gray]%s \c-", _WoundCounter, sb.FormatNumber(sealedWounds, 3));
		}

		if (openWounds == 0 && patchedWounds == 0 && sealedWounds == 0) {
			_WoundCounter = "\c[Gray]  0\c-";
		}
	}

	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
		bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);
		int  hudLevel  = hasHelmet ? _hlm_hudLevel.GetInt() : _nhm_hudLevel.GetInt();
		
		if (
			!_enabled.GetBool()
			|| ((!hasHelmet && _hlm_required.GetBool()) || (_hh_showbleed && !_hh_showbleed.GetBool())) 
			|| ((_hh_showbleedwhenbleeding && _hh_showbleedwhenbleeding.GetBool()) && _WoundCounter == "\c[Gray]  0\c-")
			|| HDSpectator(sb.hpl)
			|| sb.HUDLevel < hudLevel
		) return;

		if (CheckCommonStuff(sb, state, ticFrac)) {
			
			int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
			int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
			float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();

			string bgRef   = hasHelmet ? _hlm_bgRef.GetString()  : _nhm_bgRef.GetString();
			int    bgPosX  = hasHelmet ? _hlm_bgPosX.GetInt()    : _nhm_bgPosX.GetInt();
			int    bgPosY  = hasHelmet ? _hlm_bgPosY.GetInt()    : _nhm_bgPosY.GetInt();
			float  bgScale = hasHelmet ? _hlm_bgScale.GetFloat() : _nhm_bgScale.GetFloat();


			// Draw HUD Element Background Image if it's defined
			sb.DrawImage(
				bgRef,
				(posX + bgPosX, posY + bgPosY),
				sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_CENTER,
				scale: (scale * bgScale, scale * bgScale)
			);

			Vector2 coords = (posX, posY);
			int of = 0;
			HDBleedingWound biggestWound = HDBleedingWound.FindBiggest(sb.hpl);

			if (biggestWound) {
				sb.DrawImage(
					"BLUDC0",
					(coords.x, coords.y + scale),
					sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_ITEM_LEFT_TOP,
					0.6,
					scale: (0.5 * scale, 0.5 * scale)
				);
				of = Clamp(int(biggestWound.Depth * 0.2), 1, 3) * scale;

				if (sb.hpl.Flip)
					of = -of;
			}

			Color fillColour = (sb.hpl.Health > 70 || !_hh_wc_usedynamiccol.GetBool())
				? Color(255, sb.SBColour.R, sb.SBColour.G, sb.SBColour.B)
				: (sb.hpl.Health > 33)
					? Color(255, 240, 210, 10)
					: Color(255, 220, 0, 0);

			sb.Fill(
				fillColour,
				coords.x + (2 * scale),
				coords.y + (of * scale),
				2 * scale,
				6 * scale,
				sb.DI_SCREEN_CENTER_BOTTOM
			);
			sb.Fill(
				fillColour,
				coords.x,
				coords.y + ((of + 2) * scale),
				6 * scale,
				2 * scale,
				sb.DI_SCREEN_CENTER_BOTTOM
			);

			if (!_hh_woundcounter || _hh_woundcounter.GetBool()) {
				sb.DrawString(
					sb.mIndexFont,
					_woundCounter,
					(coords.x + (4 * scale), coords.y + scale),
					sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_TEXT_ALIGN_LEFT,
					scale: (scale, scale)
				);
			}
		}
	}
}
