class UZCompass : HUDCompass {

    private transient Service _HHFunc;

    private transient CVar _enabled;

    private transient CVar _font;
    private transient CVar _fontScale;

    private transient CVar _units;

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

    override void Init(HCStatusbar sb) {
        super.Init(sb);

        _HHFunc = ServiceIterator.Find("HHFunc").Next();
    }

    override void Tick(HCStatusbar sb) {
        if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_"..Namespace.."_enabled", sb.CPlayer);

        if (!_font) _font                 = CVar.GetCVar("uz_hhx_"..Namespace.."_font", sb.CPlayer);
        if (!_fontScale) _fontScale       = CVar.GetCVar("uz_hhx_"..Namespace.."_fontScale", sb.CPlayer);

        if (!_units) _units               = CVar.GetCVar("uz_hhx_compass_units", sb.CPlayer);

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
    }

    override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
        bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);
        int  hudLevel  = hasHelmet ? _hlm_hudLevel.GetInt() : _nhm_hudLevel.GetInt();

        if (
            !_enabled.GetBool()
            || (!hasHelmet && _hlm_required.GetBool())
            || sb.HUDLevel < hudLevel
        ) return;

        if (CheckCommonStuff(sb, state, ticFrac)) {

            int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
            int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
            float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();
            float fontScale = _fontScale.GetFloat();

            string bgRef   = hasHelmet ? _hlm_bgRef.GetString()  : _nhm_bgRef.GetString();
            int    bgPosX  = hasHelmet ? _hlm_bgPosX.GetInt()    : _nhm_bgPosX.GetInt();
            int    bgPosY  = hasHelmet ? _hlm_bgPosY.GetInt()    : _nhm_bgPosY.GetInt();
            float  bgScale = hasHelmet ? _hlm_bgScale.GetFloat() : _nhm_bgScale.GetFloat();

            // Draw HUD Element Background Image if it's defined
            sb.DrawImage(
                bgRef,
                (posX + bgPosX, posY + bgPosY),
                sb.DI_TOPLEFT,
                scale: (scale * bgScale, scale * bgScale)
            );

            double angle = sb.hpl.angle % 360;

            // TODO: Configure different color sets?
            //   - IRL Compass   N/S/E/W => Red/White/White/White
            //   - Vanilla HDest N/S/E/W => White/Black/Gold/Red
            drawCardinalDirection(
                sb,
                "$EAST",
                sb.hpl.deltaangle(0, angle),
                (posX, posY),
                sb.DI_SCREEN_LEFT_TOP|sb.DI_TEXT_ALIGN_CENTER,
                Font.CR_GOLD,
                fontScale * scale
            );

            drawCardinalDirection(
                sb,
                "$SOUTH",
                sb.hpl.deltaangle(-90, angle),
                (posX, posY),
                sb.DI_SCREEN_LEFT_TOP|sb.DI_TEXT_ALIGN_CENTER,
                Font.CR_BLACK,
                fontScale * scale
            );

            drawCardinalDirection(
                sb,
                "$WEST",
                sb.hpl.deltaangle(180, angle),
                (posX, posY),
                sb.DI_SCREEN_LEFT_TOP|sb.DI_TEXT_ALIGN_CENTER,
                Font.CR_RED,
                fontScale * scale
            );

            drawCardinalDirection(
                sb,
                "$NORTH",
                sb.hpl.deltaangle(90, angle),
                (posX, posY),
                sb.DI_SCREEN_LEFT_TOP|sb.DI_TEXT_ALIGN_CENTER,
                Font.CR_WHITE,
                fontScale * scale
            );

            HHX.DrawString(
                sb,
                _hudFont,
                "^",
                (posX, posY + (_hudFont.mFont.GetHeight() * fontScale * scale)),
                sb.DI_SCREEN_LEFT_TOP|sb.DI_TEXT_ALIGN_CENTER,
                Font.CR_OLIVE,
                fontScale * scale
            );
            
            HHX.DrawString(
                sb,
                _hudFont,
                FormatPositionValue(sb, sb.hpl.pos),
                (posX, posY + (_hudFont.mFont.GetHeight() * 2 * fontScale * scale)),
                sb.DI_SCREEN_LEFT_TOP|sb.DI_TEXT_ALIGN_CENTER,
                Font.CR_OLIVE,
                fontScale * scale
            );
        }
    }

    private void DrawCardinalDirection(HCStatusbar sb, string text, double angle, Vector2 pos, int flags, int fontColor, double scale) {

        // TODO: extract max angle into config/CVAR
        if(abs(angle) < 120) {
            HHX.DrawString(
                sb,
                _hudFont,
                StringTable.localize(text),
                (pos.x + (angle * 32 * scale / sb.cplayer.fov), pos.y),
                sb.DI_SCREEN_LEFT_TOP|sb.DI_TEXT_ALIGN_CENTER,
                fontColor,
                scale
            );
        }
    }

    private string FormatPositionValue(HCStatusbar sb, Vector3 value) {

        Vector3 pos;
        string units;
        switch (_units.GetInt()) {
            case 0:
                pos  = value / HDCONST_ONEMETRE * 1.0;
                units = "m";
                break;
            case 1:
                pos  = value / HDCONST_ONEMETRE / 1000.;
                units = "km";
                break;
            case 2:
                pos  = value / HDCONST_ONEMETRE * HDCONST_METRETOFEET;
                units = "ft";
                break;
            case 3:
                pos  = value / HDCONST_ONEMETRE * HDCONST_METRETOFEET * HDCONST_FEETTOMILE;
                units = "mi";
                break;
            default:
                pos  = value;
                units = "mu";
                break;
        }

        return String.Format("%.2f, %.2f, %.2f %s", pos.x, pos.y, pos.z, units);
    }
}
