class UZKeys : HUDKeys {

    private transient Service _HHFunc;

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

    private transient CVar _nhm_bgRef;
    private transient CVar _nhm_bgPosX;
    private transient CVar _nhm_bgPosY;
    private transient CVar _nhm_bgScale;
    private transient CVar _hlm_bgRef;
    private transient CVar _hlm_bgPosX;
    private transient CVar _hlm_bgPosY;
    private transient CVar _hlm_bgScale;

    override void Init(HCStatusbar sb) {
        super.Init(sb);

        _HHFunc = ServiceIterator.Find("HHFunc").Next();
    }

    override void Tick(HCStatusbar sb) {
        if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_keys_enabled", sb.CPlayer);

        if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_keys_hlm_required", sb.CPlayer);
        if (!_hlm_hudLevel) _hlm_hudLevel = CVar.GetCVar("uz_hhx_keys_hlm_hudLevel", sb.CPlayer);
        if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_keys_hlm_posX", sb.CPlayer);
        if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_keys_hlm_posY", sb.CPlayer);
        if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_keys_hlm_scale", sb.CPlayer);
        if (!_hlm_xScale) _hlm_xScale     = CVar.GetCVar("uz_hhx_keys_hlm_xScale", sb.CPlayer);
        if (!_hlm_yScale) _hlm_yScale     = CVar.GetCVar("uz_hhx_keys_hlm_yScale", sb.CPlayer);
        if (!_nhm_hudLevel) _nhm_hudLevel = CVar.GetCVar("uz_hhx_keys_nhm_hudLevel", sb.CPlayer);
        if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_keys_nhm_posX", sb.CPlayer);
        if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_keys_nhm_posY", sb.CPlayer);
        if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_keys_nhm_scale", sb.CPlayer);
        if (!_nhm_xScale) _nhm_xScale     = CVar.GetCVar("uz_hhx_keys_nhm_xScale", sb.CPlayer);
        if (!_nhm_yScale) _nhm_yScale     = CVar.GetCVar("uz_hhx_keys_nhm_yScale", sb.CPlayer);

        if (!_nhm_bgRef) _nhm_bgRef       = CVar.GetCVar("uz_hhx_keys_bg_nhm_ref", sb.CPlayer);
        if (!_nhm_bgPosX) _nhm_bgPosX     = CVar.GetCVar("uz_hhx_keys_bg_nhm_posX", sb.CPlayer);
        if (!_nhm_bgPosY) _nhm_bgPosY     = CVar.GetCVar("uz_hhx_keys_bg_nhm_posY", sb.CPlayer);
        if (!_nhm_bgScale) _nhm_bgScale   = CVar.GetCVar("uz_hhx_keys_bg_nhm_scale", sb.CPlayer);
        if (!_hlm_bgRef) _hlm_bgRef       = CVar.GetCVar("uz_hhx_keys_bg_hlm_ref", sb.CPlayer);
        if (!_hlm_bgPosX) _hlm_bgPosX     = CVar.GetCVar("uz_hhx_keys_bg_hlm_posX", sb.CPlayer);
        if (!_hlm_bgPosY) _hlm_bgPosY     = CVar.GetCVar("uz_hhx_keys_bg_hlm_posY", sb.CPlayer);
        if (!_hlm_bgScale) _hlm_bgScale   = CVar.GetCVar("uz_hhx_keys_bg_hlm_scale", sb.CPlayer);
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

        if (AutomapActive) {
            if(sb.hpl.countinv("BlueCard"))    sb.drawimage("BKEYB0", (10,24), sb.DI_TOPLEFT);
            if(sb.hpl.countinv("YellowCard"))  sb.drawimage("YKEYB0", (10,44), sb.DI_TOPLEFT);
            if(sb.hpl.countinv("RedCard"))     sb.drawimage("RKEYB0", (10,64), sb.DI_TOPLEFT);
            if(sb.hpl.countinv("BlueSkull"))   sb.drawimage("BSKUA0", (6,30),  sb.DI_TOPLEFT);
            if(sb.hpl.countinv("YellowSkull")) sb.drawimage("YSKUA0", (6,50),  sb.DI_TOPLEFT);
            if(sb.hpl.countinv("RedSkull"))    sb.drawimage("RSKUB0", (6,70),  sb.DI_TOPLEFT);
        } else if (CheckCommonStuff(sb, state, ticFrac)) {
        
            int   posX   = hasHelmet ? _hlm_posX.GetInt()     : _nhm_posX.GetInt();
            int   posY   = hasHelmet ? _hlm_posY.GetInt()     : _nhm_posY.GetInt();
            float scale  = hasHelmet ? _hlm_scale.GetFloat()  : _nhm_scale.GetFloat();
            float xScale = hasHelmet ? _hlm_xScale.GetFloat() : _nhm_xScale.GetFloat();
            float yScale = hasHelmet ? _hlm_yScale.GetFloat() : _nhm_yScale.GetFloat();

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
        
            // Blue Key(s)
            string keytype="";
            if(sb.hpl.countinv("BlueCard"))  keytype = "STKEYS0";
            if(sb.hpl.countinv("BlueSkull")) keytype = keyType == "" ? "STKEYS3" : "STKEYS6";
            if(keytype!="")sb.drawimage(
                keytype,
                (posX + (12 * xScale), posY - (12 * yScale)),
                sb.DI_SCREEN_CENTER_BOTTOM,
                scale: (scale, scale)
            );
            
            // Yellow Key(s)
            keytype="";
            if(sb.hpl.countinv("YellowCard"))  keytype = "STKEYS1";
            if(sb.hpl.countinv("YellowSkull")) keytype = keytype == "" ? "STKEYS4" : "STKEYS7";
            if(keytype!="")sb.drawimage(
                keytype,
                (posX + (6 * xScale), posY - (6 * yScale)),
                sb.DI_SCREEN_CENTER_BOTTOM,
                scale: (scale, scale)
            );
            
            // Red Key(s)
            keytype="";
            if(sb.hpl.countinv("RedCard"))  keytype = "STKEYS2";
            if(sb.hpl.countinv("RedSkull")) keytype = keytype == "" ? "STKEYS5" : "STKEYS8";
            if(keytype!="")sb.drawimage(
                keytype,
                (posX, posY),
                sb.DI_SCREEN_CENTER_BOTTOM,
                scale: (scale, scale)
            );
        }
    }
}
