enum HHX_COUNTER_STYLE {
    VALUE_ONLY,
    LABEL_WITH_VALUE,
    ICON_WITH_VALUE,
    DURABILITY_BAR,
    FADING_ICON
}

class BaseCounterHUDElement : HUDElement abstract {

    mixin UZBetterDrawBar;

    protected string counterIcon;
    protected string counterIconBG;
    protected string counterLabel;

    private transient Service _HHFunc;

    private transient CVar _enabled;

    private transient CVar _alwaysVisible;
    private transient CVar _counterStyle;
    private transient CVar _font;
    private transient CVar _fontColor;
    private transient CVar _fontScale;
    private transient CVar _barDirection;
    private transient CVar _maxValue;
    
    private transient CVar _nhm_hudLevel;
    private transient CVar _nhm_posX;
    private transient CVar _nhm_posY;
    private transient CVar _nhm_scale;

    private transient CVar _hlm_required;
    private transient CVar _hlm_hudLevel;
    private transient CVar _hlm_posX;
    private transient CVar _hlm_posY;
    private transient CVar _hlm_scale;

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
        counterIcon   = "";
        counterLabel  = "";
        counterIconBG = "";
    }
    
    override void Tick(HCStatusbar sb) {
        if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

        if (!_enabled) _enabled             = CVar.GetCVar("uz_hhx_"..Namespace.."_enabled", sb.CPlayer);

        if (!_alwaysVisible) _alwaysVisible = CVar.GetCVar("uz_hhx_"..Namespace.."_alwaysVisible", sb.CPlayer);
        if (!_counterStyle) _counterStyle   = CVar.GetCVar("uz_hhx_"..Namespace.."_style", sb.CPlayer);
        if (!_font) _font                   = CVar.GetCVar("uz_hhx_"..Namespace.."_font", sb.CPlayer);
        if (!_fontColor) _fontColor         = CVar.GetCVar("uz_hhx_"..Namespace.."_fontColor", sb.CPlayer);
        if (!_fontScale) _fontScale         = CVar.GetCVar("uz_hhx_"..Namespace.."_fontScale", sb.CPlayer);
        if (!_barDirection) _barDirection   = CVar.GetCVar("uz_hhx_"..Namespace.."_barDirection", sb.CPlayer);
        if (!_maxValue) _maxValue           = CVar.GetCVar("uz_hhx_"..Namespace.."_maxValue", sb.CPlayer);

        if (!_hlm_required) _hlm_required   = CVar.GetCVar("uz_hhx_"..Namespace.."_hlm_required", sb.CPlayer);
        if (!_hlm_hudLevel) _hlm_hudLevel   = CVar.GetCVar("uz_hhx_"..Namespace.."_hlm_hudLevel", sb.CPlayer);
        if (!_hlm_posX) _hlm_posX           = CVar.GetCVar("uz_hhx_"..Namespace.."_hlm_posX", sb.CPlayer);
        if (!_hlm_posY) _hlm_posY           = CVar.GetCVar("uz_hhx_"..Namespace.."_hlm_posY", sb.CPlayer);
        if (!_hlm_scale) _hlm_scale         = CVar.GetCVar("uz_hhx_"..Namespace.."_hlm_scale", sb.CPlayer);
        if (!_nhm_hudLevel) _nhm_hudLevel   = CVar.GetCVar("uz_hhx_"..Namespace.."_nhm_hudLevel", sb.CPlayer);
        if (!_nhm_posX) _nhm_posX           = CVar.GetCVar("uz_hhx_"..Namespace.."_nhm_posX", sb.CPlayer);
        if (!_nhm_posY) _nhm_posY           = CVar.GetCVar("uz_hhx_"..Namespace.."_nhm_posY", sb.CPlayer);
        if (!_nhm_scale) _nhm_scale         = CVar.GetCVar("uz_hhx_"..Namespace.."_nhm_scale", sb.CPlayer);

        if (!_nhm_bgRef) _nhm_bgRef         = CVar.GetCVar("uz_hhx_"..Namespace.."_bg_nhm_ref", sb.CPlayer);
        if (!_nhm_bgPosX) _nhm_bgPosX       = CVar.GetCVar("uz_hhx_"..Namespace.."_bg_nhm_posX", sb.CPlayer);
        if (!_nhm_bgPosY) _nhm_bgPosY       = CVar.GetCVar("uz_hhx_"..Namespace.."_bg_nhm_posY", sb.CPlayer);
        if (!_nhm_bgScale) _nhm_bgScale     = CVar.GetCVar("uz_hhx_"..Namespace.."_bg_nhm_scale", sb.CPlayer);
        if (!_hlm_bgRef) _hlm_bgRef         = CVar.GetCVar("uz_hhx_"..Namespace.."_bg_hlm_ref", sb.CPlayer);
        if (!_hlm_bgPosX) _hlm_bgPosX       = CVar.GetCVar("uz_hhx_"..Namespace.."_bg_hlm_posX", sb.CPlayer);
        if (!_hlm_bgPosY) _hlm_bgPosY       = CVar.GetCVar("uz_hhx_"..Namespace.."_bg_hlm_posY", sb.CPlayer);
        if (!_hlm_bgScale) _hlm_bgScale     = CVar.GetCVar("uz_hhx_"..Namespace.."_bg_hlm_scale", sb.CPlayer);

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
            || HDSpectator(sb.hpl)
            || !(sb.HUDLevel >= hudLevel)
        ) return;

        if (AutomapActive) {
            DrawCounter(sb, 56, -14);
        } else if (CheckCommonStuff(sb, state, ticFrac)) {

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
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_LEFT_BOTTOM,
                scale: (scale * bgScale, scale * bgScale)
            );
            
            DrawCounter(sb, posX, posY, scale);
        }
    }

    virtual bool ShouldDrawCounter(HCStatusbar sb, float counterValue) {
        return counterValue > 0;
    }

    virtual float GetCounterValue(HCStatusbar sb){
        return 0;
    }

    virtual float GetCounterMaxValue(HCStatusbar sb){
        return _maxValue ? _maxValue.GetInt() : 0;
    }

    virtual string FormatValue(HCStatusbar sb, float counterValue, float maxValue) {
        return sb.FormatNumber(counterValue);
    }

    protected void DrawCounter(HCStatusbar sb, int posX, int posY, float scale = 1.) {
        let value    = GetCounterValue(sb);
        let maxValue = GetCounterMaxValue(sb);

        if (hd_debug && !(Level.time % TICRATE)) Console.PrintF("["..Namespace.."] Value: "..value..", Max Value: "..maxValue);

        if (hd_debug || _alwaysVisible.GetBool() || ShouldDrawCounter(sb, value)) {
            float fontScale = _fontScale.GetFloat();
            switch (_counterStyle ? _counterStyle.GetInt() : LABEL_WITH_VALUE) {
                case VALUE_ONLY:
                    sb.DrawString(
                        _hudFont,
                        FormatValue(sb, value, maxValue),
                        (posX + (8 * scale), posY + scale),
                        sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_LEFT,
                        _fontColor.GetInt(),
                        scale: (fontScale * scale, fontScale * scale)
                    );
                    break;
                case LABEL_WITH_VALUE:
                    sb.DrawString(
                        _hudFont,
                        counterLabel..FormatValue(sb, value, maxValue),
                        (posX + (8 * scale), posY + scale),
                        sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_LEFT,
                        _fontColor.GetInt(),
                        scale: (fontScale * scale, fontScale * scale)
                    );
                    break;
                case ICON_WITH_VALUE:
                    sb.DrawImage(
                        counterIcon,
                        (posX, posY),
                        sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP,
                        0.6,
                        scale: (scale, scale)
                    );

                    sb.DrawString(
                        _hudFont,
                        FormatValue(sb, value, maxValue),
                        (posX + (8 * scale), posY + scale),
                        sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_TEXT_ALIGN_LEFT,
                        _fontColor.GetInt(),
                        scale: (fontScale * scale, fontScale * scale)
                    );
                    break;
                case DURABILITY_BAR:
                    BetterDrawBar(
                        sb,
                        counterIcon, counterIconBG,
                        clamp(value / max(maxValue, 1.0), 0.0, 1.0),
                        (posX, posY),
                        sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP,
                        _barDirection.GetInt(),
                        (scale, scale)
                    );
                    break;
                case FADING_ICON:
                    sb.DrawImage(
                        counterIcon,
                        (posX, posY),
                        sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP,
                        clamp(value / max(maxValue, 1.0), 0.0, 1.0),
                        scale: (scale, scale)
                    );
                    break;
                default:
                    console.printf('UNKNOWN COUNTER STYLE: '.._counterStyle.GetInt());
            }
        }
    }
}