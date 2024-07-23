class UZHDArmourStats {
    // The "Equipment Slot".  0 = body, 1 = head, 2 = boots
    transient int slot;

    // The worn layer, used to sort by outermost armour
    transient int wornlayer;

    // The foreground image to render
    transient string fg;

    // The background image to render
    transient string bg;

    // The current armour durability
    transient int durability;

    // The armour's maximum durability
    transient int maxDurability;

    // The Durability font color
    transient int fontColor;

    // The horizontal offset of the rendered graphic
    transient int offX;

    // The vertical offset of the rendered graphic
    transient int offY;

    // The alignment flags for the rendered graphic
    transient int flags;

    // The horizontal offset of the armour durability
    transient int durOffX;

    // The vertical offset of the armour durability
    transient int durOffY;
}

class UZArmour : HUDElement {

    private Service _HHFunc;
    private Service _SpicyAirService;

    private transient CVar _hh_durabilitytop;
    private transient CVar _hh_helmetoffsety;

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
    
    private transient CVar _helmet_hlm_posX;
    private transient CVar _helmet_hlm_posY;
    private transient CVar _helmet_hlm_scale;
    private transient CVar _helmet_nhm_posX;
    private transient CVar _helmet_nhm_posY;
    private transient CVar _helmet_nhm_scale;
    
    private transient CVar _body_hlm_posX;
    private transient CVar _body_hlm_posY;
    private transient CVar _body_hlm_scale;
    private transient CVar _body_nhm_posX;
    private transient CVar _body_nhm_posY;
    private transient CVar _body_nhm_scale;
    
    private transient CVar _boots_hlm_posX;
    private transient CVar _boots_hlm_posY;
    private transient CVar _boots_hlm_scale;
    private transient CVar _boots_nhm_posX;
    private transient CVar _boots_nhm_posY;
    private transient CVar _boots_nhm_scale;

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

    private transient Array<UZHDArmourStats> _arms;
    private transient Array<int> _slots;

    override void Init(HCStatusbar sb) {
        ZLayer    = 0;
        Namespace = "armour";
    }

    override void Tick(HCStatusbar sb) {
        if (!_HHFunc) _HHFunc                     = ServiceIterator.Find("HHFunc").Next();
        if (!_SpicyAirService) _SpicyAirService   = ServiceIterator.Find("SpicyAirService").Next();
        
        if (!_hh_durabilitytop) _hh_durabilitytop = CVar.GetCVar("hh_durabilitytop", sb.CPlayer);
        if (!_hh_helmetoffsety) _hh_helmetoffsety = CVar.GetCVar("hh_helmetoffsety", sb.CPlayer);

        // Global CVARs
        if (!_enabled) _enabled                   = CVar.GetCVar("uz_hhx_armour_enabled", sb.CPlayer);
        if (!_font) _font                         = CVar.GetCVar("uz_hhx_armour_font", sb.CPlayer);
        if (!_fontScale) _fontScale               = CVar.GetCVar("uz_hhx_armour_fontScale", sb.CPlayer);

        if (!_hlm_required) _hlm_required         = CVar.GetCVar("uz_hhx_armour_hlm_required", sb.CPlayer);
        if (!_hlm_hudLevel) _hlm_hudLevel         = CVar.GetCVar("uz_hhx_armour_hlm_hudLevel", sb.CPlayer);
        if (!_hlm_posX) _hlm_posX                 = CVar.GetCVar("uz_hhx_armour_hlm_posX", sb.CPlayer);
        if (!_hlm_posY) _hlm_posY                 = CVar.GetCVar("uz_hhx_armour_hlm_posY", sb.CPlayer);
        if (!_hlm_scale) _hlm_scale               = CVar.GetCVar("uz_hhx_armour_hlm_scale", sb.CPlayer);
        if (!_nhm_hudLevel) _nhm_hudLevel         = CVar.GetCVar("uz_hhx_armour_nhm_hudLevel", sb.CPlayer);
        if (!_nhm_posX) _nhm_posX                 = CVar.GetCVar("uz_hhx_armour_nhm_posX", sb.CPlayer);
        if (!_nhm_posY) _nhm_posY                 = CVar.GetCVar("uz_hhx_armour_nhm_posY", sb.CPlayer);
        if (!_nhm_scale) _nhm_scale               = CVar.GetCVar("uz_hhx_armour_nhm_scale", sb.CPlayer);

        if (!_nhm_bgRef) _nhm_bgRef               = CVar.GetCVar("uz_hhx_armour_bg_nhm_ref", sb.CPlayer);
        if (!_nhm_bgPosX) _nhm_bgPosX             = CVar.GetCVar("uz_hhx_armour_bg_nhm_posX", sb.CPlayer);
        if (!_nhm_bgPosY) _nhm_bgPosY             = CVar.GetCVar("uz_hhx_armour_bg_nhm_posY", sb.CPlayer);
        if (!_nhm_bgScale) _nhm_bgScale           = CVar.GetCVar("uz_hhx_armour_bg_nhm_scale", sb.CPlayer);
        if (!_hlm_bgRef) _hlm_bgRef               = CVar.GetCVar("uz_hhx_armour_bg_hlm_ref", sb.CPlayer);
        if (!_hlm_bgPosX) _hlm_bgPosX             = CVar.GetCVar("uz_hhx_armour_bg_hlm_posX", sb.CPlayer);
        if (!_hlm_bgPosY) _hlm_bgPosY             = CVar.GetCVar("uz_hhx_armour_bg_hlm_posY", sb.CPlayer);
        if (!_hlm_bgScale) _hlm_bgScale           = CVar.GetCVar("uz_hhx_armour_bg_hlm_scale", sb.CPlayer);

        // Helmet Slot Offsets
        if (!_helmet_hlm_posX) _helmet_hlm_posX   = CVar.GetCVar("uz_hhx_armour_helmet_hlm_posX", sb.CPlayer);
        if (!_helmet_hlm_posY) _helmet_hlm_posY   = CVar.GetCVar("uz_hhx_armour_helmet_hlm_posY", sb.CPlayer);
        if (!_helmet_hlm_scale) _helmet_hlm_scale = CVar.GetCVar("uz_hhx_armour_helmet_hlm_scale", sb.CPlayer);
        if (!_helmet_nhm_posX) _helmet_nhm_posX   = CVar.GetCVar("uz_hhx_armour_helmet_nhm_posX", sb.CPlayer);
        if (!_helmet_nhm_posY) _helmet_nhm_posY   = CVar.GetCVar("uz_hhx_armour_helmet_nhm_posY", sb.CPlayer);
        if (!_helmet_nhm_scale) _helmet_nhm_scale = CVar.GetCVar("uz_hhx_armour_helmet_nhm_scale", sb.CPlayer);

        // Body Slot Offsets
        if (!_body_hlm_posX) _body_hlm_posX       = CVar.GetCVar("uz_hhx_armour_body_hlm_posX", sb.CPlayer);
        if (!_body_hlm_posY) _body_hlm_posY       = CVar.GetCVar("uz_hhx_armour_body_hlm_posY", sb.CPlayer);
        if (!_body_hlm_scale) _body_hlm_scale     = CVar.GetCVar("uz_hhx_armour_body_hlm_scale", sb.CPlayer);
        if (!_body_nhm_posX) _body_nhm_posX       = CVar.GetCVar("uz_hhx_armour_body_nhm_posX", sb.CPlayer);
        if (!_body_nhm_posY) _body_nhm_posY       = CVar.GetCVar("uz_hhx_armour_body_nhm_posY", sb.CPlayer);
        if (!_body_nhm_scale) _body_nhm_scale     = CVar.GetCVar("uz_hhx_armour_body_nhm_scale", sb.CPlayer);

        // Boot Slot Offsets
        if (!_boots_hlm_posX) _boots_hlm_posX     = CVar.GetCVar("uz_hhx_armour_boots_hlm_posX", sb.CPlayer);
        if (!_boots_hlm_posY) _boots_hlm_posY     = CVar.GetCVar("uz_hhx_armour_boots_hlm_posY", sb.CPlayer);
        if (!_boots_hlm_scale) _boots_hlm_scale   = CVar.GetCVar("uz_hhx_armour_boots_hlm_scale", sb.CPlayer);
        if (!_boots_nhm_posX) _boots_nhm_posX     = CVar.GetCVar("uz_hhx_armour_boots_nhm_posX", sb.CPlayer);
        if (!_boots_nhm_posY) _boots_nhm_posY     = CVar.GetCVar("uz_hhx_armour_boots_nhm_posY", sb.CPlayer);
        if (!_boots_nhm_scale) _boots_nhm_scale   = CVar.GetCVar("uz_hhx_armour_boots_nhm_scale", sb.CPlayer);

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
        
        int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
        int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
        float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();

        string bgRef   = hasHelmet ? _hlm_bgRef.GetString()  : _nhm_bgRef.GetString();
        int    bgPosX  = hasHelmet ? _hlm_bgPosX.GetInt()    : _nhm_bgPosX.GetInt();
        int    bgPosY  = hasHelmet ? _hlm_bgPosY.GetInt()    : _nhm_bgPosY.GetInt();
        float  bgScale = hasHelmet ? _hlm_bgScale.GetFloat() : _nhm_bgScale.GetFloat();
        
        // Draw HUD Element Background Image if it's defined
        if (CheckCommonStuff(sb, state, ticFrac)) {
            sb.DrawImage(
                bgRef,
                (posX + bgPosX, posY + bgPosY),
                sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP,
                scale: (scale * bgScale, scale * bgScale)
            );
        }

        // Build list of metadata about currently worn armors
        BuildArmourStats(sb);

        // Initialize Armor Slot counts
        int slotIcons[3];

        // Loop through the list and render each item's icon
        for (int i = 0; i < _arms.Size(); i++) {
            let arm = _arms[i];

            // Get any Texture Offsets defined for the sprite in case it helps align it
            Vector2 offsets = TexMan.GetScaledOffset(TexMan.CheckForTexture(arm.fg));

            if (arm.maxDurability > 0) {

                // If the equipment has a valid durability, render using the durability bar
                if (AutomapActive) {
                    DrawArmour(
                        sb,
                        arm.fg,
                        arm.bg,
                        arm.durability,
                        arm.maxDurability,
                        sb.DI_TOPLEFT,
                        4 + arm.offX - offsets.x,
                        86 + arm.offY - offsets.y
                    );
                } else if (CheckCommonStuff(sb, state, ticFrac)) {
                    DrawArmour(
                        sb,
                        arm.fg,
                        arm.bg,
                        arm.durability,
                        arm.maxDurability,
                        arm.flags,
                        posX + arm.offX - offsets.x,
                        posY + arm.offY - offsets.y
                    );
                }
            } else {

                // Otherwise, simply draw the item sprite
                if (AutomapActive) {
                    sb.DrawImage(
                        arm.fg,
                        (11 + arm.offX - offsets.x, 137 + arm.offY - offsets.y),
                        sb.DI_TOPLEFT
                    );
                } else {
                    sb.DrawImage(
                        arm.fg,
                        (posX + arm.offX - offsets.x, posY + arm.offY - offsets.y),
                        arm.flags
                    );
                }
            }
            
            slotIcons[arm.slot]++;
        }

        // Initialize Armor Slot counts
        string slotDurabilities[3];

        // Loop through the list and render each item's durability text
        for (int i = 0; i < _arms.Size(); i++) {
            let arm = _arms[i];

            // Only draw equipment with actual durability
            if (arm.maxDurability > 0) {

                // Only draw the durability if HHelmet isn't installed or we have a helmet equipped
                if (!_HHFunc || _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl)) {
                    float fontScale = _fontScale.GetFloat();

                    // If the armor has a valid durability, render using the durability bar
                    if (AutomapActive) {
                        DrawDurability(
                            sb,
                            arm.durability,
                            sb.DI_TOPLEFT,
                            arm.fontColor,
                            14 + arm.offX + arm.durOffX - (_hudFont.mFont.StringWidth(slotDurabilities[arm.slot]) * fontScale * scale),
                            79 + arm.offY + arm.durOffY + (arm.slot == 1 ? (_hh_durabilitytop && _hh_durabilitytop.GetBool() ? -10 : -3) : 0),
                            fontScale * scale
                        );
                    } else if (CheckCommonStuff(sb, state, ticFrac)) {
                        DrawDurability(
                            sb,
                            arm.durability,
                            sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_TEXT_ALIGN_RIGHT,
                            arm.fontColor,
                            posX + arm.offX + arm.durOffX - (_hudFont.mFont.StringWidth(slotDurabilities[arm.slot]) * fontScale * scale),
                            posY + arm.offY + arm.durOffY + (arm.slot == 1 ? (_hh_durabilitytop && _hh_durabilitytop.GetBool() ? -10 : -3) : 0),
                            fontScale * scale
                        );
                    }
            
                    slotDurabilities[arm.slot] = slotDurabilities[arm.slot]..arm.durability.."";
                }
            }
        }
    }
    
    void DrawArmour(HCStatusBar sb, string fg, string bg, int durability, int maxDurability, int flags, int posX, int posY) {
        sb.DrawBar(
            fg, bg,
            durability, maxDurability,
            (posX, posY),
            -1,
            sb.SHADER_VERT,
            flags
        );
    }

    void drawDurability(HCStatusBar sb, int durability, int flags, int fontColor, int posX, int posY, float scale = 1.) {
        sb.DrawString(
            _hudFont,
            sb.FormatNumber(durability),
            (posX, posY - 4),
            flags,
            fontColor,
            scale: (scale, scale)
        );
    }

    private void BuildArmourStats(HCStatusbar sb) {
        bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);
        _arms.clear();

        // Process current inventory items, filtering out all non-worn armors
        for (let item = sb.hpl.inv; item != NULL; item = item.inv) {
            // Back Out early if it's not a pickup or weapon
            // mostly for "weapons" like Spicy Air's Gas Mask
            let wpn = HDWeapon(item);
            let hp = HDPickup(item);
            if (!(hp || wpn)) continue;

            let stats = GetArmourStats(sb, item, hasHelmet);

            // If we have a built stats object, add it
            if (stats) {
                _arms.push(stats);
            }
        }

        // Finally, sort the armours list by their slot, then worn layer
        SortArmours(0, _arms.Size() - 1);
    }

    private UZHDArmourStats GetArmourStats(HCStatusbar sb, Inventory item, bool hasHelmet) {
        UZHDArmourStats stats = New("UZHDArmourStats");
        
        // For grabbing the current durability
        let arm = HDArmourWorn(item);

        // Process only known worn armors
        let cls = item.GetClassName();
        if (cls == "HDArmourWorn") {
            stats.slot = 0;
            stats.wornlayer = STRIP_ARMOUR;
            stats.fg = arm.mega ? "ARMOURU0" : "ARMOURG0";
            stats.bg = arm.mega ? "ARMOURU1" : "ARMOURG1";
            stats.durability = arm.durability;
            stats.fontColor = arm.mega ? Font.CR_ICE : Font.CR_OLIVE;
            stats.maxDurability = arm.mega ? HDCONST_BATTLEARMOUR : HDCONST_GARRISONARMOUR;
            stats.offX = hasHelmet ? _body_hlm_posX.GetInt() : _body_nhm_posX.GetInt();
            stats.offY = hasHelmet ? _body_hlm_posY.GetInt() : _body_nhm_posY.GetInt();
            stats.durOffX = 15;
            stats.durOffY = 15;
            stats.flags = sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP;
        } else if (cls == "HDArmorPlateWorn") {
            stats.slot = 0;
            stats.wornlayer = STRIP_ARMOUR + 20; // STRIP_ARMORPLATE
            stats.fg = "ARMOURP0";
            stats.bg = "ARMOURP1";
            stats.durability = arm.durability;
            stats.fontColor = Font.CR_GRAY;
            stats.maxDurability = 25; // DUR_ARMORPLATE
            stats.offX = hasHelmet ? _body_hlm_posX.GetInt() : _body_nhm_posX.GetInt();
            stats.offY = hasHelmet ? _body_hlm_posY.GetInt() : _body_nhm_posY.GetInt();
            stats.durOffX = 15;
            stats.durOffY = 15;
            stats.flags = sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP;
        } else if (cls == "HDCorporateArmourWorn") {
            stats.slot = 0;
            stats.wornlayer = STRIP_ARMOUR;
            stats.fg = "ARMOURC0";
            stats.bg = "ARMOURC1";
            stats.durability = arm.durability;
            stats.maxDurability = 40;
            stats.fontColor = Font.CR_DARKGRAY;
            stats.offX = (hasHelmet ? _body_hlm_posX.GetInt() : _body_nhm_posX.GetInt());
            stats.offY = (hasHelmet ? _body_hlm_posY.GetInt() : _body_nhm_posY.GetInt());
            stats.durOffX = 15;
            stats.durOffY = 15;
            stats.flags = sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP;
        } else if (cls == "HHelmetWorn") {
            stats.slot = 1;
            stats.wornlayer = 1500; // HHelmet normally 0, overriding for rendering priority
            stats.fg = "HELMETA0";
            stats.bg = "HELMETA1";
            stats.durability = arm.durability;
            stats.maxDurability = 72;
            stats.fontColor = Font.CR_TAN;
            stats.offX = hasHelmet ? _helmet_hlm_posX.GetInt() : _helmet_nhm_posX.GetInt();
            stats.offY = (hasHelmet ? _helmet_hlm_posY.GetInt() : _helmet_nhm_posY.GetInt()) + (_hh_helmetoffsety ? _hh_helmetoffsety.GetInt() : 0);
            stats.durOffX = 7;
            stats.durOffY = 15;
            stats.flags = sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP;
        } else if (cls == "HDHEVArmourWorn") {
            stats.slot = 0;
            stats.wornlayer = STRIP_ARMOUR;
            stats.fg = "ARMOURH0";
            stats.bg = "ARMOURH1";
            stats.durability = arm.durability;
            stats.maxDurability = 107; // HDCONST_HEVARMOUR
            stats.fontColor = Font.CR_ORANGE;
            stats.offX = hasHelmet ? _body_hlm_posX.GetInt() : _body_nhm_posX.GetInt();
            stats.offY = hasHelmet ? _body_hlm_posY.GetInt() : _body_nhm_posY.GetInt();
            stats.durOffX = 15;
            stats.durOffY = 15;
            stats.flags = sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP;
        } else if (cls == "HDLeatherArmourWorn") {
            stats.slot = 0;
            stats.wornlayer = 1200; // STRIP_JACKET
            stats.fg = "ARMOURL0";
            stats.bg = "ARMOURL1";
            stats.durability = arm.durability;
            stats.maxDurability = 50; // LEATHERARMOUR
            stats.fontColor = Font.CR_BROWN;
            stats.offX = hasHelmet ? _body_hlm_posX.GetInt() : _body_nhm_posX.GetInt();
            stats.offY = hasHelmet ? _body_hlm_posY.GetInt() : _body_nhm_posY.GetInt();
            stats.durOffX = 15;
            stats.durOffY = 15;
            stats.flags = sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP;
        } else if (cls == "WAN_SneakingSuitWorn") {
            stats.slot = 0;
            stats.wornlayer = STRIP_ARMOUR;
            stats.fg = "ARMOURS0";
            stats.bg = "ARMOURS1";
            stats.durability = arm.durability;
            stats.maxDurability = 144; // HDCONST_SNEAKINGSUIT
            stats.fontColor = Font.CR_DARKGRAY;
            stats.offX = hasHelmet ? _body_hlm_posX.GetInt() : _body_nhm_posX.GetInt();
            stats.offY = hasHelmet ? _body_hlm_posY.GetInt() : _body_nhm_posY.GetInt();
            stats.durOffX = 15;
            stats.durOffY = 15;
            stats.flags = sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP;
        } else if (cls == "WornRadBoots") {
            stats.slot = 2;
            stats.wornlayer = 1500; // STRIP_RADBOOTS
            stats.fg = "RADBUTA0";
            stats.bg = "RADBUTA0";
            stats.durability = 0;
            stats.maxDurability = 0;
            stats.fontColor = Font.CR_GRAY;
            stats.offX = hasHelmet ? _boots_hlm_posX.GetInt() : _boots_nhm_posX.GetInt();
            stats.offY = hasHelmet ? _boots_hlm_posY.GetInt() : _boots_nhm_posY.GetInt();
            stats.durOffX = -7;
            stats.durOffY = 15;
            stats.flags = sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_RIGHT_TOP;
        } else if (cls == "WornRadsuit") {
            stats.slot = 0;
            stats.wornlayer = STRIP_RADSUIT;
            stats.fg = "RADSUTA0";
            stats.bg = "RADSUTA0";
            stats.durability = 0;
            stats.maxDurability = 0;
            stats.fontColor = Font.CR_WHITE;
            stats.offX = hasHelmet ? _body_hlm_posX.GetInt() : _body_nhm_posX.GetInt();
            stats.offY = hasHelmet ? _body_hlm_posY.GetInt() : _body_nhm_posY.GetInt();
            stats.durOffX = 15;
            stats.durOffY = 15;
            stats.flags = sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP;
        } else if (cls == "WornAntiGravBoots") {
            stats.slot = 2;
            stats.wornlayer = 1400; // STRIP_ANTIGRAVBOOTS
            stats.fg = "AGRVBTA0";
            stats.bg = "AGRVBTA0";
            stats.durability = 0;
            stats.maxDurability = 0;
            stats.fontColor = Font.CR_GRAY;
            stats.offX = hasHelmet ? _boots_hlm_posX.GetInt() : _boots_nhm_posX.GetInt();
            stats.offY = hasHelmet ? _boots_hlm_posY.GetInt() : _boots_nhm_posY.GetInt();
            stats.durOffX = -7;
            stats.durOffY = 15;
            stats.flags = sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_RIGHT_TOP;
        } else if (cls == "HDMagicShield") {
            let shields = sb.hpl.countinv("HDMagicShield");
            let graphic = shields < 341 ? "SHIELDB0" : shields < 682 ? "SHIELDC0" : "SHIELDD0";

            stats.slot = 1;
            stats.wornlayer = 3000; // Abitrary, just needs to be above everything else
            stats.fg = graphic;
            stats.bg = graphic;
            stats.durability = shields;
            stats.maxDurability = 1024;
            stats.fontColor = Font.CR_SAPPHIRE;
            stats.offX = hasHelmet ? _helmet_hlm_posX.GetInt() : _helmet_nhm_posX.GetInt();
            stats.offY = (hasHelmet ? _helmet_hlm_posY.GetInt() : _helmet_nhm_posY.GetInt()) + (_hh_helmetoffsety ? _hh_helmetoffsety.GetInt() : 0);
            stats.durOffX = 7;
            stats.durOffY = 15;
            stats.flags = sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP;
        } else if (cls == "Despicyto" && _SpicyAirService.GetIntUI("IsGasMaskWorn", objectArg: item)) {
            let graphic = "GASMASK".._SpicyAirService.GetStringUI("GetGasMaskSpriteIndex", objectArg: item);

            stats.slot = 1;
            stats.wornlayer = STRIP_RADSUIT + 1;
            stats.fg = graphic;
            stats.bg = graphic;
            stats.durability = _SpicyAirService.GetIntUI("GetTotalAir", objectArg: item);
            stats.maxDurability = 100;
            stats.fontColor = Font.CR_DARKGRAY;
            stats.offX = hasHelmet ? _helmet_hlm_posX.GetInt() : _helmet_nhm_posX.GetInt();
            stats.offY = hasHelmet ? _helmet_hlm_posY.GetInt() : _helmet_nhm_posY.GetInt();
            stats.durOffX = 7;
            stats.durOffY = 15;
            stats.flags = sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP;
        } else {
            stats = NULL;
        }

        return stats;
    }
    
    // Quick Sort taken from HCStatusBar
    private void SortArmours(int minIndex, int maxIndex) {
        if (minIndex >= maxIndex) return;

        int leftIndex = minIndex;
        int rightIndex = maxIndex - 1;

        // Pick pivot
        int pivotIndex = maxIndex;
        UZHDArmourStats pivot = _arms[pivotIndex];

        while (leftIndex < rightIndex) {
            // Find a value less than to the pivot
            while (leftIndex < rightIndex && _arms[leftIndex].wornlayer < pivot.wornlayer) ++leftIndex;

            // Find a value larger than/equal to the pivot
            while (leftIndex < rightIndex && _arms[rightIndex].wornlayer >= pivot.wornlayer) --rightIndex;

            if (leftIndex >= rightIndex) break;

            // Swap
            UZHDArmourStats tmp = _arms[leftIndex];
            _arms[leftIndex]    = _arms[rightIndex];
            _arms[rightIndex]   = tmp;
        }

        // Try to swap pivot
        if (leftIndex < pivotIndex && _arms[leftIndex].wornlayer > pivot.wornlayer) {
            UZHDArmourStats tmp = _arms[leftIndex];
            _arms[leftIndex]    = pivot;
            _arms[pivotIndex]   = tmp;
            pivotIndex          = leftIndex;
        }

        SortArmours(minIndex, pivotIndex - 1);
        SortArmours(pivotIndex + 1, maxIndex);
    }
}
