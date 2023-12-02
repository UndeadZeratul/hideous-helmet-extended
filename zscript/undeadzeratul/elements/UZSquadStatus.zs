class UZSquadStatus : HUDElement {

    private Service _HHFunc;

    private transient CVar _enabled;
	private transient CVar _font;
	private transient CVar _fontScale;

    private transient CVar _nhm_hudLevel;
    private transient CVar _nhm_posX;
    private transient CVar _nhm_posY;
    private transient CVar _nhm_scale;
    private transient CVar _nhm_scaleX;
    private transient CVar _nhm_scaleY;

    private transient CVar _hlm_required;
    private transient CVar _hlm_hudLevel;
    private transient CVar _hlm_posX;
    private transient CVar _hlm_posY;
    private transient CVar _hlm_scale;
    private transient CVar _hlm_scaleX;
    private transient CVar _hlm_scaleY;

    private transient CVar _nhm_bgRef;
    private transient CVar _nhm_bgPosX;
    private transient CVar _nhm_bgPosY;
    private transient CVar _nhm_bgScale;
    private transient CVar _hlm_bgRef;
    private transient CVar _hlm_bgPosX;
    private transient CVar _hlm_bgPosY;
    private transient CVar _hlm_bgScale;

    private transient CVar _name_enabled;
    private transient CVar _name_nhm_posX;
    private transient CVar _name_nhm_posY;
    private transient CVar _name_nhm_scale;
    private transient CVar _name_hlm_posX;
    private transient CVar _name_hlm_posY;
    private transient CVar _name_hlm_scale;
    
    private transient CVar _weapon_enabled;
    private transient CVar _weapon_nhm_posX;
    private transient CVar _weapon_nhm_posY;
    private transient CVar _weapon_nhm_scale;
    private transient CVar _weapon_hlm_posX;
    private transient CVar _weapon_hlm_posY;
    private transient CVar _weapon_hlm_scale;
    
    private transient CVar _ekg_enabled;
    private transient CVar _ekg_nhm_posX;
    private transient CVar _ekg_nhm_posY;
    private transient CVar _ekg_nhm_scale;
    private transient CVar _ekg_nhm_length;
    private transient CVar _ekg_hlm_posX;
    private transient CVar _ekg_hlm_posY;
    private transient CVar _ekg_hlm_scale;
    private transient CVar _ekg_hlm_length;
    
    private transient CVar _encumbrance_enabled;
    private transient CVar _encumbrance_nhm_posX;
    private transient CVar _encumbrance_nhm_posY;
    private transient CVar _encumbrance_nhm_scale;
    private transient CVar _encumbrance_hlm_posX;
    private transient CVar _encumbrance_hlm_posY;
    private transient CVar _encumbrance_hlm_scale;
    
    private transient CVar _mugshot_enabled;
    private transient CVar _mugshot_nhm_posX;
    private transient CVar _mugshot_nhm_posY;
    private transient CVar _mugshot_nhm_scale;
    private transient CVar _mugshot_hlm_posX;
    private transient CVar _mugshot_hlm_posY;
    private transient CVar _mugshot_hlm_scale;

	private transient string _prevFont;
	private transient HUDFont _hudFont;
    
    private transient Array<int> _healthBars[MAXPLAYERS];

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "squadStatus";
    }

    override void Tick(HCStatusbar sb) {
        if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

        if (!_enabled) _enabled                             = CVar.GetCVar("uz_hhx_squadStatus_enabled", sb.CPlayer);
        if (!_font) _font                                   = CVar.GetCVar("uz_hhx_squadStatus_font", sb.CPlayer);
		if (!_fontScale) _fontScale                         = CVar.GetCVar("uz_hhx_squadStatus_fontScale", sb.CPlayer);

        if (!_hlm_required) _hlm_required                   = CVar.GetCVar("uz_hhx_squadStatus_hlm_required", sb.CPlayer);
        if (!_hlm_hudLevel) _hlm_hudLevel                   = CVar.GetCVar("uz_hhx_squadStatus_hlm_hudLevel", sb.CPlayer);
        if (!_hlm_posX) _hlm_posX                           = CVar.GetCVar("uz_hhx_squadStatus_hlm_posX", sb.CPlayer);
        if (!_hlm_posY) _hlm_posY                           = CVar.GetCVar("uz_hhx_squadStatus_hlm_posY", sb.CPlayer);
        if (!_hlm_scale) _hlm_scale                         = CVar.GetCVar("uz_hhx_squadStatus_hlm_scale", sb.CPlayer);
        if (!_hlm_scaleX) _hlm_scaleX                       = CVar.GetCVar("uz_hhx_squadStatus_hlm_xscale", sb.CPlayer);
        if (!_hlm_scaleY) _hlm_scaleY                       = CVar.GetCVar("uz_hhx_squadStatus_hlm_yscale", sb.CPlayer);
        if (!_nhm_hudLevel) _nhm_hudLevel                   = CVar.GetCVar("uz_hhx_squadStatus_nhm_hudLevel", sb.CPlayer);
        if (!_nhm_posX) _nhm_posX                           = CVar.GetCVar("uz_hhx_squadStatus_nhm_posX", sb.CPlayer);
        if (!_nhm_posY) _nhm_posY                           = CVar.GetCVar("uz_hhx_squadStatus_nhm_posY", sb.CPlayer);
        if (!_nhm_scale) _nhm_scale                         = CVar.GetCVar("uz_hhx_squadStatus_nhm_scale", sb.CPlayer);
        if (!_nhm_scaleX) _nhm_scaleX                       = CVar.GetCVar("uz_hhx_squadStatus_nhm_xscale", sb.CPlayer);
        if (!_nhm_scaleY) _nhm_scaleY                       = CVar.GetCVar("uz_hhx_squadStatus_nhm_yscale", sb.CPlayer);

        if (!_nhm_bgRef) _nhm_bgRef                         = CVar.GetCVar("uz_hhx_squadStatus_bg_nhm_ref", sb.CPlayer);
        if (!_nhm_bgPosX) _nhm_bgPosX                       = CVar.GetCVar("uz_hhx_squadStatus_bg_nhm_posX", sb.CPlayer);
        if (!_nhm_bgPosY) _nhm_bgPosY                       = CVar.GetCVar("uz_hhx_squadStatus_bg_nhm_posY", sb.CPlayer);
        if (!_nhm_bgScale) _nhm_bgScale                     = CVar.GetCVar("uz_hhx_squadStatus_bg_nhm_scale", sb.CPlayer);
        if (!_hlm_bgRef) _hlm_bgRef                         = CVar.GetCVar("uz_hhx_squadStatus_bg_hlm_ref", sb.CPlayer);
        if (!_hlm_bgPosX) _hlm_bgPosX                       = CVar.GetCVar("uz_hhx_squadStatus_bg_hlm_posX", sb.CPlayer);
        if (!_hlm_bgPosY) _hlm_bgPosY                       = CVar.GetCVar("uz_hhx_squadStatus_bg_hlm_posY", sb.CPlayer);
        if (!_hlm_bgScale) _hlm_bgScale                     = CVar.GetCVar("uz_hhx_squadStatus_bg_hlm_scale", sb.CPlayer);

        if (!_name_enabled) _name_enabled                   = CVar.GetCVar("uz_hhx_squadStatus_name_enabled", sb.CPlayer);
        if (!_name_nhm_posX) _name_nhm_posX                 = CVar.GetCVar("uz_hhx_squadStatus_name_nhm_posX", sb.CPlayer);
        if (!_name_nhm_posY) _name_nhm_posY                 = CVar.GetCVar("uz_hhx_squadStatus_name_nhm_posY", sb.CPlayer);
        if (!_name_nhm_scale) _name_nhm_scale               = CVar.GetCVar("uz_hhx_squadStatus_name_nhm_scale", sb.CPlayer);
        if (!_name_hlm_posX) _name_hlm_posX                 = CVar.GetCVar("uz_hhx_squadStatus_name_hlm_posX", sb.CPlayer);
        if (!_name_hlm_posY) _name_hlm_posY                 = CVar.GetCVar("uz_hhx_squadStatus_name_hlm_posY", sb.CPlayer);
        if (!_name_hlm_scale) _name_hlm_scale               = CVar.GetCVar("uz_hhx_squadStatus_name_hlm_scale", sb.CPlayer);

        if (!_weapon_enabled) _weapon_enabled               = CVar.GetCVar("uz_hhx_squadStatus_weapon_enabled", sb.CPlayer);
        if (!_weapon_nhm_posX) _weapon_nhm_posX             = CVar.GetCVar("uz_hhx_squadStatus_weapon_nhm_posX", sb.CPlayer);
        if (!_weapon_nhm_posY) _weapon_nhm_posY             = CVar.GetCVar("uz_hhx_squadStatus_weapon_nhm_posY", sb.CPlayer);
        if (!_weapon_nhm_scale) _weapon_nhm_scale           = CVar.GetCVar("uz_hhx_squadStatus_weapon_nhm_scale", sb.CPlayer);
        if (!_weapon_hlm_posX) _weapon_hlm_posX             = CVar.GetCVar("uz_hhx_squadStatus_weapon_hlm_posX", sb.CPlayer);
        if (!_weapon_hlm_posY) _weapon_hlm_posY             = CVar.GetCVar("uz_hhx_squadStatus_weapon_hlm_posY", sb.CPlayer);
        if (!_weapon_hlm_scale) _weapon_hlm_scale           = CVar.GetCVar("uz_hhx_squadStatus_weapon_hlm_scale", sb.CPlayer);

        if (!_ekg_enabled) _ekg_enabled                     = CVar.GetCVar("uz_hhx_squadStatus_ekg_enabled", sb.CPlayer);
        if (!_ekg_nhm_posX) _ekg_nhm_posX                   = CVar.GetCVar("uz_hhx_squadStatus_ekg_nhm_posX", sb.CPlayer);
        if (!_ekg_nhm_posY) _ekg_nhm_posY                   = CVar.GetCVar("uz_hhx_squadStatus_ekg_nhm_posY", sb.CPlayer);
        if (!_ekg_nhm_scale) _ekg_nhm_scale                 = CVar.GetCVar("uz_hhx_squadStatus_ekg_nhm_scale", sb.CPlayer);
        if (!_ekg_nhm_length) _ekg_nhm_length               = CVar.GetCVar("uz_hhx_squadStatus_ekg_nhm_length", sb.CPlayer);
        if (!_ekg_hlm_posX) _ekg_hlm_posX                   = CVar.GetCVar("uz_hhx_squadStatus_ekg_hlm_posX", sb.CPlayer);
        if (!_ekg_hlm_posY) _ekg_hlm_posY                   = CVar.GetCVar("uz_hhx_squadStatus_ekg_hlm_posY", sb.CPlayer);
        if (!_ekg_hlm_scale) _ekg_hlm_scale                 = CVar.GetCVar("uz_hhx_squadStatus_ekg_hlm_scale", sb.CPlayer);
        if (!_ekg_hlm_length) _ekg_hlm_length               = CVar.GetCVar("uz_hhx_squadStatus_ekg_hlm_length", sb.CPlayer);

        if (!_encumbrance_enabled) _encumbrance_enabled     = CVar.GetCVar("uz_hhx_squadStatus_encumbrance_enabled", sb.CPlayer);
        if (!_encumbrance_nhm_posX) _encumbrance_nhm_posX   = CVar.GetCVar("uz_hhx_squadStatus_encumbrance_nhm_posX", sb.CPlayer);
        if (!_encumbrance_nhm_posY) _encumbrance_nhm_posY   = CVar.GetCVar("uz_hhx_squadStatus_encumbrance_nhm_posY", sb.CPlayer);
        if (!_encumbrance_nhm_scale) _encumbrance_nhm_scale = CVar.GetCVar("uz_hhx_squadStatus_encumbrance_nhm_scale", sb.CPlayer);
        if (!_encumbrance_hlm_posX) _encumbrance_hlm_posX   = CVar.GetCVar("uz_hhx_squadStatus_encumbrance_hlm_posX", sb.CPlayer);
        if (!_encumbrance_hlm_posY) _encumbrance_hlm_posY   = CVar.GetCVar("uz_hhx_squadStatus_encumbrance_hlm_posY", sb.CPlayer);
        if (!_encumbrance_hlm_scale) _encumbrance_hlm_scale = CVar.GetCVar("uz_hhx_squadStatus_encumbrance_hlm_scale", sb.CPlayer);

        if (!_mugshot_enabled) _mugshot_enabled             = CVar.GetCVar("uz_hhx_squadStatus_mugshot_enabled", sb.CPlayer);
        if (!_mugshot_nhm_posX) _mugshot_nhm_posX           = CVar.GetCVar("uz_hhx_squadStatus_mugshot_nhm_posX", sb.CPlayer);
        if (!_mugshot_nhm_posY) _mugshot_nhm_posY           = CVar.GetCVar("uz_hhx_squadStatus_mugshot_nhm_posY", sb.CPlayer);
        if (!_mugshot_nhm_scale) _mugshot_nhm_scale         = CVar.GetCVar("uz_hhx_squadStatus_mugshot_nhm_scale", sb.CPlayer);
        if (!_mugshot_hlm_posX) _mugshot_hlm_posX           = CVar.GetCVar("uz_hhx_squadStatus_mugshot_hlm_posX", sb.CPlayer);
        if (!_mugshot_hlm_posY) _mugshot_hlm_posY           = CVar.GetCVar("uz_hhx_squadStatus_mugshot_hlm_posY", sb.CPlayer);
        if (!_mugshot_hlm_scale) _mugshot_hlm_scale         = CVar.GetCVar("uz_hhx_squadStatus_mugshot_hlm_scale", sb.CPlayer);

		string newFont = _font.GetString();
		if (_prevFont != newFont) {
			_hudFont = HUDFont.create(Font.FindFont(newFont));
			_prevFont = newFont;
		}
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

        int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
        int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
        float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();

        string bgRef   = hasHelmet ? _hlm_bgRef.GetString()  : _nhm_bgRef.GetString();
        int    bgPosX  = hasHelmet ? _hlm_bgPosX.GetInt()    : _nhm_bgPosX.GetInt();
        int    bgPosY  = hasHelmet ? _hlm_bgPosY.GetInt()    : _nhm_bgPosY.GetInt();
        float  bgScale = hasHelmet ? _hlm_bgScale.GetFloat() : _nhm_bgScale.GetFloat();

        int offX = 0;
        int offY = 0;

        for (int i = 0; i < MAXPLAYERS; ++i) {

            // Get the next player.  If that player doesn't exist or is the current player, skip.
            let plr = HDPlayerPawn(players[i].mo);
            if (
                !plr
                || StatusBar.CPlayer.mo == plr
                || HDSpectator(plr)
            ) continue;

            // Check if player has helmet if required, otherwise skip.
            bool plrHasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: plr);
            if (!plrHasHelmet && _hlm_required.GetBool()) continue;
            
            float xOff = hasHelmet ? _hlm_scaleX.GetFloat() : _nhm_scaleX.GetFloat();
            float yOff = hasHelmet ? _hlm_scaleY.GetFloat() : _nhm_scaleY.GetFloat();
            
            int   nameOffX  = hasHelmet ? _name_hlm_posX.GetInt()    : _name_nhm_posX.GetInt();
            int   nameOffY  = hasHelmet ? _name_hlm_posY.GetInt()    : _name_nhm_posY.GetInt();
            float nameScale = hasHelmet ? _name_hlm_scale.GetFloat() : _name_nhm_scale.GetFloat();

            int   wpnOffX  = hasHelmet ? _weapon_hlm_posX.GetInt()    : _weapon_nhm_posX.GetInt();
            int   wpnOffY  = hasHelmet ? _weapon_hlm_posY.GetInt()    : _weapon_nhm_posY.GetInt();
            float wpnScale = hasHelmet ? _weapon_hlm_scale.GetFloat() : _weapon_nhm_scale.GetFloat();
                
            int   ekgOffX   = hasHelmet ? _ekg_hlm_posX.GetInt()    : _ekg_nhm_posX.GetInt();
            int   ekgOffY   = hasHelmet ? _ekg_hlm_posY.GetInt()    : _ekg_nhm_posY.GetInt();
            float ekgScale  = hasHelmet ? _ekg_hlm_scale.GetFloat() : _ekg_nhm_scale.GetFloat();
            int   ekgLength = hasHelmet ? _ekg_hlm_length.GetInt()  : _ekg_nhm_length.GetInt();

            int   encOffX  = hasHelmet ? _encumbrance_hlm_posX.GetInt()    : _encumbrance_nhm_posX.GetInt();
            int   encOffY  = hasHelmet ? _encumbrance_hlm_posY.GetInt()    : _encumbrance_nhm_posY.GetInt();
            float encScale = hasHelmet ? _encumbrance_hlm_scale.GetFloat() : _encumbrance_nhm_scale.GetFloat();
            
            int   mugOffX  = hasHelmet ? _mugshot_hlm_posX.GetInt()    : _mugshot_nhm_posX.GetInt();
            int   mugOffY  = hasHelmet ? _mugshot_hlm_posY.GetInt()    : _mugshot_nhm_posY.GetInt();
            float mugScale = hasHelmet ? _mugshot_hlm_scale.GetFloat() : _mugshot_nhm_scale.GetFloat();

            if (AutomapActive) {
                // TODO: Draw Squad Status when Automap on
            } else if (CheckCommonStuff(sb, state, ticFrac)) {

                // Draw HUD Element Background Image if it's defined
                sb.DrawImage(
                    bgRef,
                    (posX + bgPosX, posY + bgPosY),
                    sb.DI_SCREEN_CENTER|sb.DI_ITEM_CENTER,
                    scale: (scale * bgScale, scale * bgScale)
                );

                // Draw Squad Statuses
                DrawName(   sb, plr, state, ticFrac, posX + offX + nameOffX, posY + offY + nameOffY, sb.DI_SCREEN_CENTER|sb.DI_TEXT_ALIGN_LEFT, scale * nameScale);
                DrawWeapon( sb, plr, state, ticFrac, posX + offX + wpnOffX,  posY + offY + wpnOffY,  sb.DI_SCREEN_CENTER|sb.DI_ITEM_LEFT,       scale * wpnScale);
                DrawEKG(    sb, plr, state, ticFrac, posX + offX + ekgOffX,  posY + offY + ekgOffY,  sb.DI_SCREEN_CENTER|sb.DI_ITEM_LEFT,       scale * ekgScale, ekgLength);
                DrawBulk(   sb, plr, state, ticFrac, posX + offX + encOffX,  posY + offY + encOffY,  sb.DI_SCREEN_CENTER|sb.DI_ITEM_LEFT,       scale * encScale);
                DrawMugshot(sb, plr, state, ticFrac, posX + offX + mugOffX,  posY + offY + mugOffY,  sb.DI_SCREEN_CENTER|sb.DI_ITEM_LEFT,       scale * mugScale);
            }

            offX += xOff * scale;
            offY += yOff * scale;
        }
    }

    void DrawName(HCStatusbar sb, HDPlayerPawn plr, int state, double ticFrac, int posX, int posY, int flags, float scale) {
        if (_name_enabled.GetBool()) {
            float fontScale = _fontScale.GetFloat();
            sb.DrawString(
                _hudFont,
                plr.player.GetUserName(),
                (posX, posY),
                flags,
                scale: (fontScale * scale, fontScale * scale)
            );
        }
    }
    
    // EKG
    void DrawEKG(HCStatusbar sb, HDPlayerPawn plr, int state, double ticFrac, int posX, int posY, int flags, float scale, int length) {
        if (_ekg_enabled.GetBool()) {
            Color sbcolour = plr.player.GetDisplayColor();

            int extra = plr.PlayerNumber();
            if (!plr.beatcount) {
                int err = random[heart](0, max(0,((100 - plr.health) >> 3)));

                _healthBars[extra].insert(0, clamp(18 - (plr.bloodloss >> 7) - (err >> 2), 1, 18));
                _healthBars[extra].insert(0, (plr.inpain ? random[heart](1, 7) : 1) + err + random[heart](0, (plr.bloodpressure >> 3)));

			    while (_healthBars[extra].Size() > length) _healthBars[extra].Pop();
            }

            if (plr.health <= 0) for (int i = 0; i < length; i++) _healthBars[extra][i] = 1;

            for (int i = 0; i < _healthBars[extra].Size(); i++) {
                int alf = (i&1) ? 128 : 255;

                sb.fill(
                    (
                        plr.health > 70
                            ? color(alf,     sbcolour.r, sbcolour.g, sbcolour.b)
                            : plr.health > 33
                                ? color(alf, 240,        210,        10)
                                : color(alf, 220,        0,          0)
                    ),
                    posX + (i * scale) - (length >> 2),
                    (posY - (_healthBars[extra][i] * 0.3 * scale)),
                    0.8 * scale,
                    _healthBars[extra][i] * 0.6 * scale,
                    flags|(plr.health > 70 ? sb.DI_TRANSLATABLE : 0)
                );
            }
        }
    }

    // Encumbrance
    void DrawBulk(HCStatusbar sb, HDPlayerPawn plr, int state, double ticFrac, int posX, int posY, int flags, float scale) {
        if (_encumbrance_enabled.GetBool() && plr.enc) {
            double pocketenc = plr.pocketenc;

            // Encumbrance Bulk Value
            float fontScale = _fontScale.GetFloat();
            sb.drawstring(
                _hudFont,
                sb.FormatNumber(int(plr.enc)),
                (posX + (4 * fontScale * scale), posY - ((_hudFont.mFont.GetHeight() >> 1) * fontScale * scale)),
                flags,
                plr.overloaded < 0.8
                    ? Font.CR_OLIVE 
                    : plr.overloaded > 1.6
                        ? Font.CR_RED
                        : Font.CR_GOLD,
                scale: (fontScale * scale, fontScale * scale)
            );

            // Encumbrance Bar Border
            sb.fill(
                color(128, 96, 96, 96),
                posX,
                posY,
                scale,
                -scale,
                flags
            );
            sb.fill(
                color(128, 96, 96, 96),
                posX + scale,
                posY,
                scale,
                -20 * scale,
                flags
            );
            sb.fill(
                color(128, 96, 96, 96),
                posX - scale,
                posY,
                scale,
                -20 * scale,
                flags
            );

            // Encumbrance Bar Fill
            sb.drawrect(
                posX,
                posY - scale,
                scale,
                (-min(plr.maxpocketspace, pocketenc) * 19 / plr.maxpocketspace) * scale,
                flags
            );

            // Over-Encumbrance Bar Fill
            bool overenc = plr.flip && pocketenc > plr.maxpocketspace;

            sb.fill(
                overenc ? color(255,216,194,42) : color(128,96,96,96),
                posX,
                posY - (19 * scale),
                scale,
                -(overenc ? 3 : 1) * scale,
                flags
            );
        }
    }

    // Mugshot
    void DrawMugshot(HCStatusbar sb, HDPlayerPawn plr, int state, double ticFrac, int posX, int posY, int flags, float scale) {
        if (_mugshot_enabled.GetBool() && sb.usemughud) {
            sb.drawTexture(
                sb.GetMugShot(5, Mugshot.CUSTOM, sb.GetMug(plr.mugshot)),
                (posX, posY),
                flags,
                sb.blurred ? 0.2 : 1.0,
                scale: (0.4 * scale, 0.4 * scale)
            );
        }
    }

    // Current Weapon
    void DrawWeapon(HCStatusbar sb, HDPlayerPawn plr, int state, double ticFrac, int posX, int posY, int flags, float scale) {
        if (_weapon_enabled.GetBool()) {
            let weapon = HDWeapon(plr.player.readyweapon);
            if (!weapon) return;
            
            string sprite;
            double spriteScale = 1.;
            [sprite, spriteScale] = weapon.GetPickupSprite();

            if (sprite != "") {
                sb.DrawImage(
                    sprite,
                    (posx, posy),
                    flags,
                    scale: spriteScale ? (spriteScale * scale, spriteScale * scale) : (scale, scale)
                );
            }
        }
    }
}
