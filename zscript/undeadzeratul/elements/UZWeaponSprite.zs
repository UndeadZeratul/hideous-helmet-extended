class UZWeaponSprite : HUDWeaponSprite {

    private Service _HHFunc;

    private transient CVar _hd_hudsprite;
    private transient CVar _r_drawplayersprites;

    private transient CVar _enabled;
    private transient CVar _hlm_required;

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

    override void Tick(HCStatusbar sb) {
        if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

        if (!_hd_hudsprite) _hd_hudsprite               = CVar.GetCVar("hd_hudsprite", sb.CPlayer);
        if (!_r_drawplayersprites) _r_drawplayersprites = CVar.GetCVar("r_drawplayersprites", sb.CPlayer);

        if (!_enabled) _enabled                         = CVar.GetCVar("uz_hhx_weaponSprite_enabled", sb.CPlayer);
        if (!_hlm_required) _hlm_required               = CVar.GetCVar("uz_hhx_weaponSprite_hlm_required", sb.CPlayer);
        if (!_hlm_hudLevel) _hlm_hudLevel               = CVar.GetCVar("uz_hhx_weaponSprite_hlm_hudLevel", sb.CPlayer);
        if (!_hlm_posX) _hlm_posX                       = CVar.GetCVar("uz_hhx_weaponSprite_hlm_posX", sb.CPlayer);
        if (!_hlm_posY) _hlm_posY                       = CVar.GetCVar("uz_hhx_weaponSprite_hlm_posY", sb.CPlayer);
        if (!_hlm_scale) _hlm_scale                     = CVar.GetCVar("uz_hhx_weaponSprite_hlm_scale", sb.CPlayer);
        if (!_nhm_hudLevel) _nhm_hudLevel               = CVar.GetCVar("uz_hhx_weaponSprite_nhm_hudLevel", sb.CPlayer);
        if (!_nhm_posX) _nhm_posX                       = CVar.GetCVar("uz_hhx_weaponSprite_nhm_posX", sb.CPlayer);
        if (!_nhm_posY) _nhm_posY                       = CVar.GetCVar("uz_hhx_weaponSprite_nhm_posY", sb.CPlayer);
        if (!_nhm_scale) _nhm_scale                     = CVar.GetCVar("uz_hhx_weaponSprite_nhm_scale", sb.CPlayer);

        if (!_nhm_bgRef) _nhm_bgRef                     = CVar.GetCVar("uz_hhx_weaponSprite_bg_nhm_ref", sb.CPlayer);
        if (!_nhm_bgPosX) _nhm_bgPosX                   = CVar.GetCVar("uz_hhx_weaponSprite_bg_nhm_posX", sb.CPlayer);
        if (!_nhm_bgPosY) _nhm_bgPosY                   = CVar.GetCVar("uz_hhx_weaponSprite_bg_nhm_posY", sb.CPlayer);
        if (!_nhm_bgScale) _nhm_bgScale                 = CVar.GetCVar("uz_hhx_weaponSprite_bg_nhm_scale", sb.CPlayer);
        if (!_hlm_bgRef) _hlm_bgRef                     = CVar.GetCVar("uz_hhx_weaponSprite_bg_hlm_ref", sb.CPlayer);
        if (!_hlm_bgPosX) _hlm_bgPosX                   = CVar.GetCVar("uz_hhx_weaponSprite_bg_hlm_posX", sb.CPlayer);
        if (!_hlm_bgPosY) _hlm_bgPosY                   = CVar.GetCVar("uz_hhx_weaponSprite_bg_hlm_posY", sb.CPlayer);
        if (!_hlm_bgScale) _hlm_bgScale                 = CVar.GetCVar("uz_hhx_weaponSprite_bg_hlm_scale", sb.CPlayer);
    }

    override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
        bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);
        int  hudLevel  = hasHelmet ? _hlm_hudLevel.GetInt() : _nhm_hudLevel.GetInt();

        if (
            !_enabled.GetBool()
            || (!hasHelmet && _hlm_required.GetBool())
            || HDSpectator(sb.hpl)
            || !(sb.HUDLevel >= hudLevel || _hd_hudsprite.GetBool() || !_r_drawplayersprites.GetBool())
        ) return;

        int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
        int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
        float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();

        if (AutomapActive) {
            DrawSelectedWeapon(sb, state, ticFrac, -80, -60, sb.DI_BOTTOMRIGHT, scale);
        } else if (CheckCommonStuff(sb, state, ticFrac)) {

            string bgRef   = hasHelmet ? _hlm_bgRef.GetString()  : _nhm_bgRef.GetString();
            int    bgPosX  = hasHelmet ? _hlm_bgPosX.GetInt()    : _nhm_bgPosX.GetInt();
            int    bgPosY  = hasHelmet ? _hlm_bgPosY.GetInt()    : _nhm_bgPosY.GetInt();
            float  bgScale = hasHelmet ? _hlm_bgScale.GetFloat() : _nhm_bgScale.GetFloat();

            // Draw HUD Element Background Image if it's defined
            sb.DrawImage(
                bgRef,
                (posX + bgPosX, posY + bgPosY),
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_LEFT_BOTTOM,
                scale: (scale * bgScale, scale * bgScale)
            );
            
            DrawSelectedWeapon(sb, state, ticFrac, posX, posY, sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_LEFT_BOTTOM, scale);
        }
    }

    private void DrawSelectedWeapon(HCStatusbar sb, int state, double ticFrac, int posX, int posY, int flags, float scale) {
        let weapon = hdweapon(sb.hpl.player.readyweapon);
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
