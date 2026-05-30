class UZTargetFriendly : HUDElement {

    private HDCoreLineTraceHandler _handler;

    private transient Service _HHFunc;

    private transient CVar _enabled;

    private transient CVar _font;
    private transient CVar _fontScale;

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

    private transient string _prevFont;
    private transient HUDFont _hudFont;

    private transient bool _friendlyStatus;

    override void Init(HCStatusbar sb) {
        ZLayer    = 2;
        Namespace = "TargetFriendly";

        _HHFunc = ServiceIterator.Find("HHFunc").Next();
    }

    override void Tick(HCStatusbar sb) {
        if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_"..Namespace.."_enabled", sb.CPlayer);

        if (!_handler) _handler           = HDCoreLineTraceHandler(EventHandler.Find('HDCoreLineTraceHandler'));

        if (!_font) _font                 = CVar.GetCVar("uz_hhx_"..Namespace.."_font", sb.CPlayer);
        if (!_fontScale) _fontScale       = CVar.GetCVar("uz_hhx_"..Namespace.."_fontScale", sb.CPlayer);

        if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_"..Namespace.."_hlm_required", sb.CPlayer);
        if (!_hlm_hudLevel) _hlm_hudLevel = CVar.GetCVar("uz_hhx_"..Namespace.."_hlm_hudLevel", sb.CPlayer);
        if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_"..Namespace.."_hlm_posX", sb.CPlayer);
        if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_"..Namespace.."_hlm_posY", sb.CPlayer);
        if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_"..Namespace.."_hlm_scale", sb.CPlayer);
        if (!_nhm_hudLevel) _nhm_hudLevel = CVar.GetCVar("uz_hhx_"..Namespace.."_nhm_hudLevel", sb.CPlayer);
        if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_"..Namespace.."_nhm_posX", sb.CPlayer);
        if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_"..Namespace.."_nhm_posY", sb.CPlayer);
        if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_"..Namespace.."_nhm_scale", sb.CPlayer);

        if (!_nhm_bgRef) _nhm_bgRef       = CVar.GetCVar("uz_hhx_"..Namespace.."_bg_nhm_ref", sb.CPlayer);
        if (!_nhm_bgPosX) _nhm_bgPosX     = CVar.GetCVar("uz_hhx_"..Namespace.."_bg_nhm_posX", sb.CPlayer);
        if (!_nhm_bgPosY) _nhm_bgPosY     = CVar.GetCVar("uz_hhx_"..Namespace.."_bg_nhm_posY", sb.CPlayer);
        if (!_nhm_bgScale) _nhm_bgScale   = CVar.GetCVar("uz_hhx_"..Namespace.."_bg_nhm_scale", sb.CPlayer);
        if (!_hlm_bgRef) _hlm_bgRef       = CVar.GetCVar("uz_hhx_"..Namespace.."_bg_hlm_ref", sb.CPlayer);
        if (!_hlm_bgPosX) _hlm_bgPosX     = CVar.GetCVar("uz_hhx_"..Namespace.."_bg_hlm_posX", sb.CPlayer);
        if (!_hlm_bgPosY) _hlm_bgPosY     = CVar.GetCVar("uz_hhx_"..Namespace.."_bg_hlm_posY", sb.CPlayer);
        if (!_hlm_bgScale) _hlm_bgScale   = CVar.GetCVar("uz_hhx_"..Namespace.."_bg_hlm_scale", sb.CPlayer);

        string newFont = _font.GetString();
        if (_prevFont != newFont) {
            let font = Font.FindFont(newFont);
            _hudFont = HUDFont.create(font ? font : Font.FindFont('NewSmallFont'));
            _prevFont = newFont;
        }

        if (_handler) _friendlyStatus = GetFriendlyStatus(sb);
    }

    private bool GetFriendlyStatus(HCStatusbar sb) {
        let data = _handler.data[sb.hpl.PlayerNumber()];

        return data
            && data.hitType == TRACE_HitActor
            && data.hitActor
            && data.hitActor.bFRIENDLY;
    }

    override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
        bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);
        int  hudLevel  = hasHelmet ? _hlm_hudLevel.GetInt() : _nhm_hudLevel.GetInt();

        if (
            !_enabled.GetBool()
            || (!hasHelmet && _hlm_required.GetBool())
            || HDSpectator(sb.hpl)
            || sb.HUDLevel < hudLevel
            || !_friendlyStatus
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
                sb.DI_SCREEN_CENTER,
                scale: (scale * bgScale, scale * bgScale)
            );
            
            float fontScale = _fontScale.GetFloat();
            sb.DrawString(
                _hudFont,
                "+",
                (posX, posY - (_hudFont.mFont.GetHeight() * fontScale * scale * 0.5)),
                sb.DI_SCREEN_CENTER|sb.DI_TEXT_ALIGN_CENTER,
                translation: Font.CR_GREEN,
                scale: (fontScale * scale, fontScale * scale)
            );
        }
    }
}