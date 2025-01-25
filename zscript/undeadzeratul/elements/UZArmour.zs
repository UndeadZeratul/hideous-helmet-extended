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

    // The offsets of the rendered graphic
    transient Vector2 offsets;

    // The offsets of the armour durability
    transient Vector2 durOffsets;

    // The visual scale of the armour slot
    transient float scale;

    // The alignment flags for the rendered graphic
    transient int flags;

    static UZHDArmourStats Create(int slot, int wornlayer, string fg, string bg, int durability, int maxDurability, int fontColor, Vector2 offsets, Vector2 durOffsets, float scale, int flags) {
        UZHDArmourStats stats = UZHDArmourStats(New("UZHDArmourStats"));

        if (stats) {
            stats.slot = slot;
            stats.wornlayer = wornlayer;
            stats.fg = fg;
            stats.bg = bg;
            stats.durability = durability;
            stats.maxDurability = maxDurability;
            stats.fontColor = fontColor;
            stats.offsets = offsets;
            stats.durOffsets = durOffsets;
            stats.scale = scale;
            stats.flags = flags;
        }

        return stats;
    }
}

class UZArmour : HUDElement {

    mixin UZBetterDrawBar;

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
    private transient CVar _durability_hlm_required;
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
        if (!_HHFunc) _HHFunc                                   = ServiceIterator.Find("HHFunc").Next();
        if (!_SpicyAirService) _SpicyAirService                 = ServiceIterator.Find("SpicyAirService").Next();
        
        if (!_hh_durabilitytop) _hh_durabilitytop               = CVar.GetCVar("hh_durabilitytop", sb.CPlayer);
        if (!_hh_helmetoffsety) _hh_helmetoffsety               = CVar.GetCVar("hh_helmetoffsety", sb.CPlayer);

        // Global CVARs
        if (!_enabled) _enabled                                 = CVar.GetCVar("uz_hhx_armour_enabled", sb.CPlayer);
        if (!_font) _font                                       = CVar.GetCVar("uz_hhx_armour_font", sb.CPlayer);
        if (!_fontScale) _fontScale                             = CVar.GetCVar("uz_hhx_armour_fontScale", sb.CPlayer);

        if (!_hlm_required) _hlm_required                       = CVar.GetCVar("uz_hhx_armour_hlm_required", sb.CPlayer);
        if (!_durability_hlm_required) _durability_hlm_required = CVar.GetCVar("uz_hhx_armour_durability_hlm_required", sb.CPlayer);
        if (!_hlm_hudLevel) _hlm_hudLevel                       = CVar.GetCVar("uz_hhx_armour_hlm_hudLevel", sb.CPlayer);
        if (!_hlm_posX) _hlm_posX                               = CVar.GetCVar("uz_hhx_armour_hlm_posX", sb.CPlayer);
        if (!_hlm_posY) _hlm_posY                               = CVar.GetCVar("uz_hhx_armour_hlm_posY", sb.CPlayer);
        if (!_hlm_scale) _hlm_scale                             = CVar.GetCVar("uz_hhx_armour_hlm_scale", sb.CPlayer);
        if (!_nhm_hudLevel) _nhm_hudLevel                       = CVar.GetCVar("uz_hhx_armour_nhm_hudLevel", sb.CPlayer);
        if (!_nhm_posX) _nhm_posX                               = CVar.GetCVar("uz_hhx_armour_nhm_posX", sb.CPlayer);
        if (!_nhm_posY) _nhm_posY                               = CVar.GetCVar("uz_hhx_armour_nhm_posY", sb.CPlayer);
        if (!_nhm_scale) _nhm_scale                             = CVar.GetCVar("uz_hhx_armour_nhm_scale", sb.CPlayer);

        if (!_nhm_bgRef) _nhm_bgRef                             = CVar.GetCVar("uz_hhx_armour_bg_nhm_ref", sb.CPlayer);
        if (!_nhm_bgPosX) _nhm_bgPosX                           = CVar.GetCVar("uz_hhx_armour_bg_nhm_posX", sb.CPlayer);
        if (!_nhm_bgPosY) _nhm_bgPosY                           = CVar.GetCVar("uz_hhx_armour_bg_nhm_posY", sb.CPlayer);
        if (!_nhm_bgScale) _nhm_bgScale                         = CVar.GetCVar("uz_hhx_armour_bg_nhm_scale", sb.CPlayer);
        if (!_hlm_bgRef) _hlm_bgRef                             = CVar.GetCVar("uz_hhx_armour_bg_hlm_ref", sb.CPlayer);
        if (!_hlm_bgPosX) _hlm_bgPosX                           = CVar.GetCVar("uz_hhx_armour_bg_hlm_posX", sb.CPlayer);
        if (!_hlm_bgPosY) _hlm_bgPosY                           = CVar.GetCVar("uz_hhx_armour_bg_hlm_posY", sb.CPlayer);
        if (!_hlm_bgScale) _hlm_bgScale                         = CVar.GetCVar("uz_hhx_armour_bg_hlm_scale", sb.CPlayer);

        // Helmet Slot Offsets
        if (!_helmet_hlm_posX) _helmet_hlm_posX                 = CVar.GetCVar("uz_hhx_armour_helmet_hlm_posX", sb.CPlayer);
        if (!_helmet_hlm_posY) _helmet_hlm_posY                 = CVar.GetCVar("uz_hhx_armour_helmet_hlm_posY", sb.CPlayer);
        if (!_helmet_hlm_scale) _helmet_hlm_scale               = CVar.GetCVar("uz_hhx_armour_helmet_hlm_scale", sb.CPlayer);
        if (!_helmet_nhm_posX) _helmet_nhm_posX                 = CVar.GetCVar("uz_hhx_armour_helmet_nhm_posX", sb.CPlayer);
        if (!_helmet_nhm_posY) _helmet_nhm_posY                 = CVar.GetCVar("uz_hhx_armour_helmet_nhm_posY", sb.CPlayer);
        if (!_helmet_nhm_scale) _helmet_nhm_scale               = CVar.GetCVar("uz_hhx_armour_helmet_nhm_scale", sb.CPlayer);

        // Body Slot Offsets
        if (!_body_hlm_posX) _body_hlm_posX                     = CVar.GetCVar("uz_hhx_armour_body_hlm_posX", sb.CPlayer);
        if (!_body_hlm_posY) _body_hlm_posY                     = CVar.GetCVar("uz_hhx_armour_body_hlm_posY", sb.CPlayer);
        if (!_body_hlm_scale) _body_hlm_scale                   = CVar.GetCVar("uz_hhx_armour_body_hlm_scale", sb.CPlayer);
        if (!_body_nhm_posX) _body_nhm_posX                     = CVar.GetCVar("uz_hhx_armour_body_nhm_posX", sb.CPlayer);
        if (!_body_nhm_posY) _body_nhm_posY                     = CVar.GetCVar("uz_hhx_armour_body_nhm_posY", sb.CPlayer);
        if (!_body_nhm_scale) _body_nhm_scale                   = CVar.GetCVar("uz_hhx_armour_body_nhm_scale", sb.CPlayer);

        // Boot Slot Offsets
        if (!_boots_hlm_posX) _boots_hlm_posX                   = CVar.GetCVar("uz_hhx_armour_boots_hlm_posX", sb.CPlayer);
        if (!_boots_hlm_posY) _boots_hlm_posY                   = CVar.GetCVar("uz_hhx_armour_boots_hlm_posY", sb.CPlayer);
        if (!_boots_hlm_scale) _boots_hlm_scale                 = CVar.GetCVar("uz_hhx_armour_boots_hlm_scale", sb.CPlayer);
        if (!_boots_nhm_posX) _boots_nhm_posX                   = CVar.GetCVar("uz_hhx_armour_boots_nhm_posX", sb.CPlayer);
        if (!_boots_nhm_posY) _boots_nhm_posY                   = CVar.GetCVar("uz_hhx_armour_boots_nhm_posY", sb.CPlayer);
        if (!_boots_nhm_scale) _boots_nhm_scale                 = CVar.GetCVar("uz_hhx_armour_boots_nhm_scale", sb.CPlayer);

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

            // Get any Texture Offsets defined for the sprite in case 't helps alig' it
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
                        4 + ((arm.offsets.x - offsets.x) * scale * arm.scale),
                        86 + ((arm.offsets.y - offsets.y) * scale * arm.scale),
                        scale * arm.scale
                    );
                } else if (CheckCommonStuff(sb, state, ticFrac)) {
                    DrawArmour(
                        sb,
                        arm.fg,
                        arm.bg,
                        arm.durability,
                        arm.maxDurability,
                        arm.flags,
                        posX + ((arm.offsets.x - offsets.x) * scale * arm.scale),
                        posY + ((arm.offsets.y - offsets.y) * scale * arm.scale),
                        scale * arm.scale
                    );
                }
            } else {

                // Otherwise, simply draw the item sprite
                if (AutomapActive) {
                    sb.DrawImage(
                        arm.fg,
                        (11 + arm.offsets.x - offsets.x, 137 + arm.offsets.y - offsets.y),
                        sb.DI_TOPLEFT
                    );
                } else {
                    sb.DrawImage(
                        arm.fg,
                        (posX + ((arm.offsets.x - offsets.x) * scale * arm.scale), posY + ((arm.offsets.y - offsets.y) * scale * arm.scale)),
                        arm.flags,
                        scale: (scale * arm.scale, scale * arm.scale)
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

                // Only draw the durability if HHelmet isn't installed, or we don't require one equipped, or we have a helmet equipped
                if (!_durability_hlm_required.GetBool() || !_HHFunc || _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl)) {
                    float fontScale = _fontScale.GetFloat();

                    // If the armor has a valid durability, render using the durability bar
                    if (AutomapActive) {
                        DrawDurability(
                            sb,
                            arm.durability,
                            sb.DI_TOPLEFT,
                            arm.fontColor,
                            14 + ((arm.offsets.x + arm.durOffsets.x - _hudFont.mFont.StringWidth(slotDurabilities[arm.slot])) * scale * fontScale * arm.scale),
                            79 + ((arm.offsets.y + arm.durOffsets.y + (arm.slot == 1 ? (_hh_durabilitytop && _hh_durabilitytop.GetBool() ? -10 : -3) : 0)) * scale * fontScale * arm.scale),
                            scale * fontScale * arm.scale
                        );
                    } else if (CheckCommonStuff(sb, state, ticFrac)) {
                        DrawDurability(
                            sb,
                            arm.durability,
                            sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_TEXT_ALIGN_RIGHT,
                            arm.fontColor,
                            posX + ((arm.offsets.x + arm.durOffsets.x - _hudFont.mFont.StringWidth(slotDurabilities[arm.slot])) * scale * fontScale * arm.scale),
                            posY + ((arm.offsets.y + arm.durOffsets.y + (arm.slot == 1 ? (_hh_durabilitytop && _hh_durabilitytop.GetBool() ? -10 : -3) : 0)) * scale * fontScale * arm.scale),
                            scale * fontScale * arm.scale
                        );
                    }
            
                    slotDurabilities[arm.slot] = slotDurabilities[arm.slot]..arm.durability.."";
                }
            }
        }
    }
    
    void DrawArmour(HCStatusBar sb, string fg, string bg, int durability, int maxDurability, int flags, int posX, int posY, double scale) {
        BetterDrawBar(
            sb,
            fg, bg,
            clamp(durability / max(maxDurability, 1.0), 0.0, 1.0),
            (posX, posY),
            flags,
            2,
            (scale, scale)
        );
    }

    void drawDurability(HCStatusBar sb, int durability, int flags, int fontColor, int posX, int posY, float scale) {
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

        let helmOffs = hasHelmet ? (_helmet_hlm_posX.GetInt(), _helmet_hlm_posY.GetInt()) : (_helmet_nhm_posX.GetInt(), _helmet_nhm_posY.GetInt());
        let bodyOffs = hasHelmet ? (_body_hlm_posX.GetInt(), _body_hlm_posY.GetInt()) : (_body_nhm_posX.GetInt(), _body_nhm_posY.GetInt());
        let bootOffs = hasHelmet ? (_boots_hlm_posX.GetInt(), _boots_hlm_posY.GetInt()) : (_boots_nhm_posX.GetInt(), _boots_nhm_posY.GetInt());

        let helmDurOffs = ( 7, 15);
        let bodyDurOffs = (15, 15);
        let bootDurOffs = (-7, 15);

        let helmScale = hasHelmet ? _helmet_hlm_scale.GetFloat() : _helmet_nhm_scale.GetFloat();
        let bodyScale = hasHelmet ? _body_hlm_scale.GetFloat() : _body_nhm_scale.GetFloat();
        let bootScale = hasHelmet ? _boots_hlm_scale.GetFloat() : _boots_nhm_scale.GetFloat();

        // For grabbing the current durability
        let arm = HDArmourWorn(item);

        // Process only known worn armors
        switch (item.GetClassName()) {
            case 'HDArmourWorn': {
                return UZHDArmourStats.Create(
                    0,
                    STRIP_ARMOUR,
                    arm.mega ? "ARMOURU0" : "ARMOURG0",
                    arm.mega ? "ARMOURU1" : "ARMOURG1",
                    arm.durability,
                    arm.mega ? HDCONST_BATTLEARMOUR : HDCONST_GARRISONARMOUR,
                    arm.mega ? Font.CR_ICE : Font.CR_OLIVE,
                    bodyOffs,
                    bodyDurOffs,
                    bodyScale,
                    sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP
                );
            }
            case 'HDArmorPlateWorn': {
                return UZHDArmourStats.Create(
                    0,
                    STRIP_ARMOUR + 20, // STRIP_ARMORPLATE
                    "ARMOURP0",
                    "ARMOURP1",
                    arm.durability,
                    25, // DUR_ARMORPLATE
                    Font.CR_GRAY,
                    bodyOffs,
                    bodyDurOffs,
                    bodyScale,
                    sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP
                );
            }
            case 'HDCorporateArmourWorn': {
                return UZHDArmourStats.Create(
                    0,
                    STRIP_ARMOUR,
                    "ARMOURP0",
                    "ARMOURP1",
                    arm.durability,
                    40, // HDCONST_CORPORATEARMOUR
                    Font.CR_DARKGRAY,
                    bodyOffs,
                    bodyDurOffs,
                    bodyScale,
                    sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP
                );
            }
            case 'HHelmetWorn': {
                return UZHDArmourStats.Create(
                    1,
                    1500, // HHelmet normally 0, overriding for rendering priority
                    "HELMETA0",
                    "HELMETA1",
                    arm.durability,
                    72, // HHCONST_HUDHELMET
                    Font.CR_TAN,
                    helmOffs,
                    helmDurOffs,
                    helmScale,
                    sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP
                );
            }
            case 'HDHEVArmourWorn': {
                return UZHDArmourStats.Create(
                    0,
                    STRIP_ARMOUR,
                    "ARMOURH0",
                    "ARMOURH1",
                    arm.durability,
                    107, // HDCONST_HEVARMOUR
                    Font.CR_ORANGE,
                    bodyOffs,
                    bodyDurOffs,
                    bodyScale,
                    sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP
                );
            }
            case 'HDLeatherArmourWorn': {
                return UZHDArmourStats.Create(
                    0,
                    1200, // STRIP_JACKET
                    "ARMOURL0",
                    "ARMOURL1",
                    arm.durability,
                    40, // LEATHERARMOUR
                    Font.CR_BROWN,
                    bodyOffs,
                    bodyDurOffs,
                    bodyScale,
                    sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP
                );
            }
            case 'WAN_SneakingSuitWorn': {
                return UZHDArmourStats.Create(
                    0,
                    STRIP_ARMOUR,
                    "ARMOURS0",
                    "ARMOURS1",
                    arm.durability,
                    144, // HDCONST_SNEAKINGSUIT
                    Font.CR_DARKGRAY,
                    bodyOffs,
                    bodyDurOffs,
                    bodyScale,
                    sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP
                );
            }
            case 'WornRadBoots': {
                return UZHDArmourStats.Create(
                    2,
                    1500, // STRIP_RADBOOTS
                    "RADBUTA0",
                    "RADBUTA0",
                    0,
                    0,
                    Font.CR_GRAY,
                    bootOffs,
                    bootDurOffs,
                    bootScale,
                    sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_RIGHT_TOP
                );
            }
            case 'WornRadsuit': {
                return UZHDArmourStats.Create(
                    0,
                    STRIP_RADSUIT,
                    "RADSUTA0",
                    "RADSUTA1",
                    0,
                    0,
                    Font.CR_WHITE,
                    bodyOffs,
                    bodyDurOffs,
                    bodyScale,
                    sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP
                );
            }
            case 'WornAntiGravBoots': {
                return UZHDArmourStats.Create(
                    2,
                    1400, // STRIP_ANTIGRAVBOOTS
                    "AGRVBTA0",
                    "AGRVBTA0",
                    0,
                    0,
                    Font.CR_GRAY,
                    bootOffs,
                    bootDurOffs,
                    bootScale,
                    sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_RIGHT_TOP
                );
            }
            case 'HDMagicShield': {
                let shields = sb.hpl.countinv("HDMagicShield");
                let graphic = shields < 341 ? "SHIELDB0" : shields < 682 ? "SHIELDC0" : "SHIELDD0";

                return UZHDArmourStats.Create(
                    1,
                    3000, // Arbitrary, just needs to be above everything else
                    graphic,
                    graphic,
                    shields,
                    1024,
                    Font.CR_SAPPHIRE,
                    helmOffs,
                    helmDurOffs,
                    helmScale,
                    sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP
                );
            }
            case 'Despicyto': {
                
                if (_SpicyAirService && _SpicyAirService.GetIntUI("IsGasMaskWorn", objectArg: item)) {
                    let graphic = "GASMASK".._SpicyAirService.GetStringUI("GetGasMaskSpriteIndex", objectArg: item);

                    return UZHDArmourStats.Create(
                        1,
                        STRIP_RADSUIT + 1,
                        graphic,
                        graphic,
                        _SpicyAirService.GetIntUI("GetTotalAir", objectArg: item),
                        100,
                        Font.CR_DARKGRAY,
                        helmOffs,
                        helmDurOffs,
                        helmScale,
                        sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_TOP
                    );
                }

                break;
            }
            default:
                break;
        }

        return null;
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
