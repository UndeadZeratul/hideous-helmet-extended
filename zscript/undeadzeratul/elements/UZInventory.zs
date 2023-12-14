class UZInventory : HUDInventory {

    private Service _HHFunc;

    private transient CVar _enabled;
    private transient CVar _font;
    private transient CVar _fontScale;
    
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

    override void Tick(HCStatusbar sb) {
        if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

        if (!_enabled) _enabled           = CVar.GetCVar("uz_hhx_inventory_enabled", sb.CPlayer);
        if (!_font) _font                 = CVar.GetCVar("uz_hhx_inventory_font", sb.CPlayer);
        if (!_fontScale) _fontScale       = CVar.GetCVar("uz_hhx_inventory_fontScale", sb.CPlayer);

        if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_inventory_hlm_required", sb.CPlayer);
        if (!_hlm_hudLevel) _hlm_hudLevel = CVar.GetCVar("uz_hhx_inventory_hlm_hudLevel", sb.CPlayer);
        if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_inventory_hlm_posX", sb.CPlayer);
        if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_inventory_hlm_posY", sb.CPlayer);
        if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_inventory_hlm_scale", sb.CPlayer);
        if (!_nhm_hudLevel) _nhm_hudLevel = CVar.GetCVar("uz_hhx_inventory_nhm_hudLevel", sb.CPlayer);
        if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_inventory_nhm_posX", sb.CPlayer);
        if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_inventory_nhm_posY", sb.CPlayer);
        if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_inventory_nhm_scale", sb.CPlayer);

        if (!_nhm_bgRef) _nhm_bgRef       = CVar.GetCVar("uz_hhx_inventory_bg_nhm_ref", sb.CPlayer);
        if (!_nhm_bgPosX) _nhm_bgPosX     = CVar.GetCVar("uz_hhx_inventory_bg_nhm_posX", sb.CPlayer);
        if (!_nhm_bgPosY) _nhm_bgPosY     = CVar.GetCVar("uz_hhx_inventory_bg_nhm_posY", sb.CPlayer);
        if (!_nhm_bgScale) _nhm_bgScale   = CVar.GetCVar("uz_hhx_inventory_bg_nhm_scale", sb.CPlayer);
        if (!_hlm_bgRef) _hlm_bgRef       = CVar.GetCVar("uz_hhx_inventory_bg_hlm_ref", sb.CPlayer);
        if (!_hlm_bgPosX) _hlm_bgPosX     = CVar.GetCVar("uz_hhx_inventory_bg_hlm_posX", sb.CPlayer);
        if (!_hlm_bgPosY) _hlm_bgPosY     = CVar.GetCVar("uz_hhx_inventory_bg_hlm_posY", sb.CPlayer);
        if (!_hlm_bgScale) _hlm_bgScale   = CVar.GetCVar("uz_hhx_inventory_bg_hlm_scale", sb.CPlayer);

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
        
        float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();

        if (AutomapActive) {
            DrawInvSel(sb, 6, 100, sb.DI_TOPLEFT, scale);
        } else if (CheckCommonStuff(sb, state, ticFrac)) {

            int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
            int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();

            string bgRef   = hasHelmet ? _hlm_bgRef.GetString()  : _nhm_bgRef.GetString();
            int    bgPosX  = hasHelmet ? _hlm_bgPosX.GetInt()    : _nhm_bgPosX.GetInt();
            int    bgPosY  = hasHelmet ? _hlm_bgPosY.GetInt()    : _nhm_bgPosY.GetInt();
            float  bgScale = hasHelmet ? _hlm_bgScale.GetFloat() : _nhm_bgScale.GetFloat();
            
            float fontScale = _fontScale.GetFloat();

            // Draw HUD Element Background Image if it's defined
            sb.DrawImage(
                bgRef,
                (posX + bgPosX, posY + bgPosY),
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_CENTER,
                scale: (scale * bgScale, scale * bgScale)
            );
            
            DrawSurroundingInv(sb, posX, posY + (10 * scale), sb.DI_SCREEN_CENTER_BOTTOM, scale);
            DrawInvSel(sb, posX, posY, sb.DI_SCREEN_CENTER_BOTTOM, scale);
        }
    }

    private void DrawInvSel(HCStatusBar sb, int posX, int posY, int flags, float scale) {
        if (sb.hpl.InvSel) {
            inventory ivs = sb.hpl.invsel;
            let ivsp = HDPickup(ivs);
            let ivsw = HDWeapon(ivs);

            sb.DrawInventoryIcon(
                ivs,
                (posX, posY),
                flags|sb.DI_ITEM_CENTER|(((ivsp && ivsp.bdroptranslation)||(ivsw && ivsw.bdroptranslation)) ? sb.DI_TRANSLATABLE : 0),
                scale: (scale, scale)
            );
            
            float fontScale = _fontScale.GetFloat();

            if (ivsp) {
                int ivspi = ivsp.getsbarnum();
                if (ivspi != -1000000) {
                    sb.DrawString(
                        _hudFont,
                        sb.FormatNumber(ivspi),
                        (posX + (17 * scale), posY - (_hudFont.mFont.GetHeight() * scale)),
                        flags|sb.DI_TEXT_ALIGN_RIGHT,
                        sb.savedcolour,
                        scale: (fontScale * scale, fontScale * scale)
                    );
                }
            } else if (ivsw) {
                int ivswi = ivsw.getsbarnum();
                if (ivswi != -1000000) {
                    sb.DrawString(
                        _hudFont,
                        sb.FormatNumber(ivswi),
                        (posX + (17 * scale), posY - (_hudFont.mFont.GetHeight() * scale)),
                        flags|sb.DI_TEXT_ALIGN_RIGHT,
                        sb.savedcolour,
                        scale: (fontScale * scale, fontScale * scale)
                    );
                }
            }

            int invamt = ivsw
                ? ivsw.displayamount()
                : ivsp
                    ? ivsp.displayamount()
                    : ivs.amount;

            sb.DrawString(
                _hudFont,
                sb.FormatNumber(invamt),
                (posX + (17 * scale), posY),
                flags|sb.DI_TEXT_ALIGN_RIGHT,
                Font.CR_OLIVE,
                scale: (fontScale * scale, fontScale * scale)
            );
        }
    }

    private void DrawSurroundingInv(HCStatusBar sb, int posX, int posY, int flags, float scale) {
        int i = 0;
        int thisindex = -1;

        Array<Inventory> items;
        items.clear();

        for (let item = sb.hpl.inv; item != NULL; item = item.inv) {

            if (!item || (!item.binvbar&& item != sb.hpl.invsel)) continue;
            
            items.push(item);
            
            if (item == sb.hpl.invsel) thisindex = i;

            i++;
        }

        // If an item isn't selected or there's less than two items in the player's inventory, quit.
        if (thisindex < 0 || items.size() < 2) return;

        int lastindex = items.size() - 1;
        int previndex = thisindex ? thisindex - 1 : lastindex;
        int nextindex = thisindex == lastindex ? 0 : thisindex + 1;

        inventory drawitems[2];

        if (items.size() > 2) drawitems[0] = items[previndex];
        drawitems[1] = items[nextindex];

        for (i = 0; i < 2; i++) {
            let thisitem = drawitems[i];

            if (!thisitem) continue;
            
            textureid icon;
            vector2 applyscale;
            [icon, applyscale] = sb.GetIcon(thisitem, 0);

            let ivsp = HDPickup(thisitem);
            let ivsw = HDWeapon(thisitem);

            sb.DrawTexture(
                icon,
                (posX + ((!i ? -10 : 10) * scale), posY - (17 * scale)),
                flags|sb.DI_ITEM_CENTER_BOTTOM|(((ivsp && ivsp.bdroptranslation) || (ivsw && ivsw.bdroptranslation)) ? sb.DI_TRANSLATABLE : 0),
                alpha: 0.6,
                scale: applyscale * 0.6 * scale
            );
        }
    }
}
