class UZFullInventory : HUDElement {

    private transient Service _HHFunc;

    private transient CVar _enabled;

    private transient CVar _font;
    private transient CVar _fontColor;
    private transient CVar _fontScale;
    
    private transient CVar _hlm_required;
    private transient CVar _hlm_hudLevel;
    private transient CVar _hlm_posX;
    private transient CVar _hlm_posY;
    private transient CVar _hlm_scale;
    private transient CVar _hlm_xScale;
    private transient CVar _hlm_yScale;
    private transient CVar _hlm_wrapLength;
    private transient CVar _nhm_hudLevel;
    private transient CVar _nhm_posX;
    private transient CVar _nhm_posY;
    private transient CVar _nhm_scale;
    private transient CVar _nhm_xScale;
    private transient CVar _nhm_yScale;
    private transient CVar _nhm_wrapLength;
    
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
        ZLayer = 0;
        Namespace = "fullInventory";

        _HHFunc = ServiceIterator.Find("HHFunc").Next();
    }

    override void Tick(HCStatusbar sb) {
        if (!_enabled) _enabled               = CVar.GetCVar("uz_hhx_fullInventory_enabled", sb.CPlayer);

        if (!_font) _font                     = CVar.GetCVar("uz_hhx_fullInventory_font", sb.CPlayer);
        if (!_fontColor) _fontColor           = CVar.GetCVar("uz_hhx_fullInventory_fontColor", sb.CPlayer);
        if (!_fontScale) _fontScale           = CVar.GetCVar("uz_hhx_fullInventory_fontScale", sb.CPlayer);

        if (!_nhm_hudLevel) _nhm_hudLevel     = CVar.GetCVar("uz_hhx_fullInventory_nhm_hudLevel", sb.CPlayer);
        if (!_nhm_posX) _nhm_posX             = CVar.GetCVar("uz_hhx_fullInventory_nhm_posX", sb.CPlayer);
        if (!_nhm_posY) _nhm_posY             = CVar.GetCVar("uz_hhx_fullInventory_nhm_posY", sb.CPlayer);
        if (!_nhm_scale) _nhm_scale           = CVar.GetCVar("uz_hhx_fullInventory_nhm_scale", sb.CPlayer);
        if (!_nhm_xScale) _nhm_xScale         = CVar.GetCVar("uz_hhx_fullInventory_nhm_xScale", sb.CPlayer);
        if (!_nhm_yScale) _nhm_yScale         = CVar.GetCVar("uz_hhx_fullInventory_nhm_yScale", sb.CPlayer);
        if (!_nhm_wrapLength) _nhm_wrapLength = CVar.GetCVar("uz_hhx_fullInventory_nhm_wrapLength", sb.CPlayer);

        if (!_hlm_required) _hlm_required     = CVar.GetCVar("uz_hhx_fullInventory_hlm_required", sb.CPlayer);
        if (!_hlm_hudLevel) _hlm_hudLevel     = CVar.GetCVar("uz_hhx_fullInventory_hlm_hudLevel", sb.CPlayer);
        if (!_hlm_posX) _hlm_posX             = CVar.GetCVar("uz_hhx_fullInventory_hlm_posX", sb.CPlayer);
        if (!_hlm_posY) _hlm_posY             = CVar.GetCVar("uz_hhx_fullInventory_hlm_posY", sb.CPlayer);
        if (!_hlm_scale) _hlm_scale           = CVar.GetCVar("uz_hhx_fullInventory_hlm_scale", sb.CPlayer);
        if (!_hlm_xScale) _hlm_xScale         = CVar.GetCVar("uz_hhx_fullInventory_hlm_xScale", sb.CPlayer);
        if (!_hlm_yScale) _hlm_yScale         = CVar.GetCVar("uz_hhx_fullInventory_hlm_yScale", sb.CPlayer);
        if (!_hlm_wrapLength) _hlm_wrapLength = CVar.GetCVar("uz_hhx_fullInventory_hlm_wrapLength", sb.CPlayer);

        if (!_nhm_bgRef) _nhm_bgRef           = CVar.GetCVar("uz_hhx_fullInventory_bg_nhm_ref", sb.CPlayer);
        if (!_nhm_bgPosX) _nhm_bgPosX         = CVar.GetCVar("uz_hhx_fullInventory_bg_nhm_posX", sb.CPlayer);
        if (!_nhm_bgPosY) _nhm_bgPosY         = CVar.GetCVar("uz_hhx_fullInventory_bg_nhm_posY", sb.CPlayer);
        if (!_nhm_bgScale) _nhm_bgScale       = CVar.GetCVar("uz_hhx_fullInventory_bg_nhm_scale", sb.CPlayer);
        if (!_hlm_bgRef) _hlm_bgRef           = CVar.GetCVar("uz_hhx_fullInventory_bg_hlm_ref", sb.CPlayer);
        if (!_hlm_bgPosX) _hlm_bgPosX         = CVar.GetCVar("uz_hhx_fullInventory_bg_hlm_posX", sb.CPlayer);
        if (!_hlm_bgPosY) _hlm_bgPosY         = CVar.GetCVar("uz_hhx_fullInventory_bg_hlm_posY", sb.CPlayer);
        if (!_hlm_bgScale) _hlm_bgScale       = CVar.GetCVar("uz_hhx_fullInventory_bg_hlm_scale", sb.CPlayer);

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
            || sb.HUDLevel < hudLevel
        ) return;

        if (CheckCommonStuff(sb, state, ticFrac)) {
            int i = 0;
            int thisindex = -1;
        
            int   posX       = hasHelmet ? _hlm_posX.GetInt()       : _nhm_posX.GetInt();
            int   posY       = hasHelmet ? _hlm_posY.GetInt()       : _nhm_posY.GetInt();
            float scale      = hasHelmet ? _hlm_scale.GetFloat()    : _nhm_scale.GetFloat();
            float xScale     = hasHelmet ? _hlm_xScale.GetFloat()   : _nhm_xScale.GetFloat();
            float yScale     = hasHelmet ? _hlm_yScale.GetFloat()   : _nhm_yScale.GetFloat();
            int   wrapLength = hasHelmet ? _hlm_wrapLength.getInt() : _nhm_wrapLength.GetInt();

            int wrap = wrapLength > 0 ? wrapLength : 5;

            string bgRef   = hasHelmet ? _hlm_bgRef.GetString()  : _nhm_bgRef.GetString();
            int    bgPosX  = hasHelmet ? _hlm_bgPosX.GetInt()    : _nhm_bgPosX.GetInt();
            int    bgPosY  = hasHelmet ? _hlm_bgPosY.GetInt()    : _nhm_bgPosY.GetInt();
            float  bgScale = hasHelmet ? _hlm_bgScale.GetFloat() : _nhm_bgScale.GetFloat();

            // Draw HUD Element Background Image if it's defined
            sb.DrawImage(
                bgRef,
                (posX + bgPosX, posY + bgPosY),
                sb.DI_SCREEN_RIGHT_BOTTOM|sb.DI_ITEM_CENTER_BOTTOM,
                scale: (scale * bgScale, scale * bgScale)
            );
            
            for (let item = sb.hpl.inv; item != NULL; item = item.inv) {
                if (!item || (!item.binvbar && item != sb.hpl.invsel)) {
                    continue;
                }
                
                if (item == sb.cplayer.mo.invsel) {
                    thisindex = i;
                }

                textureid icon;
                vector2   applyscale;
                
                [icon,applyscale] = sb.geticon(item, 0);
                
                int  row    = (i / wrap) * 20;
                int  col    = (i % wrap) * 20;
                int  xoffs  = col * scale;
                int  yoffs  = row * scale;
                bool isthis = i == thisindex;
                
                let ivsh = HDPickup(item);
                let ivsw = HDWeapon(item);
                let ivsb = HDBackpack(item);
            
                Vector2 coords = (posX - xoffs - (row * xScale), posY + sb.bigitemyofs - yoffs - (col * yScale));

                // sb.DrawImage(
                //     icon,
                //     coords + (0, sb.bigitemyofs),
                //     sb.DI_SCREEN_RIGHT_BOTTOM|sb.DI_ITEM_RIGHT_BOTTOM
                //     |((
                //         (ivsh && ivsh.bdroptranslation)
                //         ||(ivsw && ivsw.bdroptranslation)
                //     ) ? sb.DI_TRANSLATABLE : 0),
                //     alpha:isthis ? 1. : 0.6,
                //     scale:applyscale * (isthis ? 1. : 0.6) * scale
                // );
                
                sb.drawtexture(
                    icon,
                    coords,
                    sb.DI_SCREEN_RIGHT_BOTTOM|sb.DI_ITEM_RIGHT_BOTTOM
                    |((
                        (ivsh && ivsh.bdroptranslation)
                        ||(ivsw && ivsw.bdroptranslation)
                    ) ? sb.DI_TRANSLATABLE : 0),
                    alpha:isthis ? 1. : 0.6,
                    scale:applyscale * (isthis ? 1. : 0.6) * scale
                );

                let amount = ivsb
                    ? ivsb.amount
                    : ivsw
                        ? ivsw.DisplayAmount()
                        : ivsh
                            ? ivsh.DisplayAmount()
                            : item.amount;

                float fontScale = _fontScale.GetFloat();
                let formattedValue = sb.FormatNumber(amount);

                // TODO: Allow Easter Egg to be disabled via CVARs
                formattedValue.replace("69", "nice");
                formattedValue.replace("6.9", "ni.ce");

                sb.DrawString(
                    _hudFont,
                    formattedValue,
                    coords + (2, 0),
                    sb.DI_SCREEN_RIGHT_BOTTOM|sb.DI_ITEM_RIGHT_BOTTOM|sb.DI_TEXT_ALIGN_RIGHT,
                    _fontColor.GetInt(),
                    scale: (fontScale * scale, fontScale * scale)
                );

                i++;
            }
        }
    }
}
