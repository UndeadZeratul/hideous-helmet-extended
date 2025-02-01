class UZBackground : HUDElement {

    private transient Service _HHFunc;
    
    private transient CVar _enabled;

    private transient CVar _ref;

    private transient CVar _hlm_required;
    private transient CVar _hlm_hudLevel;
    private transient CVar _hlm_posX;
    private transient CVar _hlm_posY;
    private transient CVar _hlm_scale;
    private transient CVar _nhm_hudLevel;
    private transient CVar _nhm_posX;
    private transient CVar _nhm_posY;
    private transient CVar _nhm_scale;
    
    override void Init(HCStatusbar sb) {
        ZLayer = -1;
        Namespace = "background";

        _HHFunc = ServiceIterator.Find("HHFunc").Next();
    }

    override void Tick(HCStatusbar sb) {
        if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_background_enabled", sb.CPlayer);

        if (!_ref) _ref                   = CVar.GetCVar("uz_hhx_background_ref", sb.CPlayer);
 
        if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_background_hlm_required", sb.CPlayer);
        if (!_hlm_hudLevel) _hlm_hudLevel = CVar.GetCVar("uz_hhx_background_hlm_hudLevel", sb.CPlayer);
        if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_background_hlm_posX", sb.CPlayer);
        if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_background_hlm_posY", sb.CPlayer);
        if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_background_hlm_scale", sb.CPlayer);
        if (!_nhm_hudLevel) _nhm_hudLevel = CVar.GetCVar("uz_hhx_background_nhm_hudLevel", sb.CPlayer);
        if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_background_nhm_posX", sb.CPlayer);
        if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_background_nhm_posY", sb.CPlayer);
        if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_background_nhm_scale", sb.CPlayer);
    }

    override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
        bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);
        int  hudLevel  = hasHelmet ? _hlm_hudLevel.GetInt() : _nhm_hudLevel.GetInt();
        
        if (
            !_enabled.GetBool()
            || (!hasHelmet && _hlm_required.GetBool())
            || sb.HUDLevel < hudLevel
        ) return;

        if(CheckCommonStuff(sb, state, ticFrac)) {
            int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
            int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
            float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();

            Vector2 bgScale = (scale / 100., scale / 100.);

            // If scale CVAR is set to "auto" or "Fit to Screen", then calculate the scale based on screen vs Background Image dimensions
            if (scale <= 0) {

                // Get the current HUD Scaling value
                Vector2 hudScale = sb.GetHUDScale();

                // Store the raw dimensions of the Background Image
                int bgWidth;
                int bgHeight;
                [bgWidth, bgHeight] = TexMan.GetSize(TexMan.CheckForTexture(_ref.GetString()));

                // Calculate the proper scaling value based on the raw dimensions between the Background Image and the screen
                Double scaleX = 1. / bgWidth / hudScale.x * Screen.GetWidth();
                Double scaleY = 1. / bgHeight / hudScale.y * Screen.GetHeight();

                // 0 = Auto, -1 = Fit to Screen
                bgScale = scale == 0
                    // If the Background Image is relatively wider than the screen, scale to the height of the two; otherwise scale to the width.
                    ? ((Double(bgWidth) / Double(bgHeight)) - Screen.GetAspectRatio()) < 0 ? (scaleX, scaleX) : (scaleY, scaleY)
                    // Simply scale each dimension to fit to the screen
                    : (scaleX, scaleY);
            }

            sb.DrawImage(
                _ref.GetString(),
                (posX, posY),
                sb.DI_SCREEN_CENTER_BOTTOM,
                scale: bgScale
            );
        }
    }
}
