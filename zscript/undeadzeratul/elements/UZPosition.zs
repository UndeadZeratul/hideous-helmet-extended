
class UZPosition : HUDPosition {
	
	// private UZStringPos3 plPos;
	
    private Service _HHFunc;

    private transient CVar _enabled;
    private transient CVar _font;
    private transient CVar _fontScale;
    private transient CVar _units;
    private transient CVar _unitsEnabled;
    private transient CVar _unitsLinebreak;
    private transient CVar _unitSuffix;
	private transient CVar _unitDir;
	private transient CVar _unitXyz;
	private transient CVar _unitPrecision;
	private transient CVar _unitRounding;
	
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
	
	bool dumped;

    override void Tick(HCStatusbar sb) {
        
		// Handler for helmet checks.
		if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();
		
		/*
		if(!plPos)
		{
			plPos = UZStringPos3(new('UZStringPos3'));
		}
		*/
		
		// Whether this module is enabled.
        if (!_enabled) _enabled     = CVar.GetCVar("uz_hhx_compass_enabled",        sb.CPlayer);
		
		// Font info.
        if (!_font) _font           = CVar.GetCVar("uz_hhx_compass_font",           sb.CPlayer);
        if (!_fontScale) _fontScale = CVar.GetCVar("uz_hhx_compass_fontScale",      sb.CPlayer); 
		
		// Units
		if (!_units)_units                    = CVar.GetCVar("uz_hhx_compass_units",           sb.CPlayer);
		if (!_unitsEnabled)_unitsEnabled      = CVar.GetCVar("uz_hhx_compass_units_enabled",   sb.CPlayer);
		if (!_unitsLinebreak)_unitsLinebreak  = CVar.GetCVar("uz_hhx_compass_unit_linebreak",  sb.CPlayer);
		if (!_unitSuffix) _unitSuffix         = CVar.GetCVar("uz_hhx_compass_unit_suffix",     sb.CPlayer);
		if (!_unitDir) _unitDir               = CVar.GetCVar("uz_hhx_compass_unit_dir",        sb.CPlayer);
		if (!_unitXyz) _unitXyz               = CVar.GetCVar("uz_hhx_compass_unit_xyz",        sb.CPlayer);
        if (!_unitPrecision) _unitPrecision   = CVar.GetCVar("uz_hhx_compass_unit_precision",  sb.CPlayer);
        if (!_unitRounding) _unitRounding     = CVar.GetCVar("uz_hhx_compass_unit_rounding",   sb.CPlayer);

		// Helmet
        if (!_hlm_required) _hlm_required = CVar.GetCVar("uz_hhx_compass_hlm_required", sb.CPlayer);
        if (!_hlm_hudLevel) _hlm_hudLevel = CVar.GetCVar("uz_hhx_compass_hlm_hudLevel", sb.CPlayer);
        if (!_hlm_posX) _hlm_posX         = CVar.GetCVar("uz_hhx_compass_hlm_posX", sb.CPlayer);
        if (!_hlm_posY) _hlm_posY         = CVar.GetCVar("uz_hhx_compass_hlm_posY", sb.CPlayer);
        if (!_hlm_scale) _hlm_scale       = CVar.GetCVar("uz_hhx_compass_hlm_scale", sb.CPlayer);
        if (!_nhm_hudLevel) _nhm_hudLevel = CVar.GetCVar("uz_hhx_compass_nhm_hudLevel", sb.CPlayer);
        if (!_nhm_posX) _nhm_posX         = CVar.GetCVar("uz_hhx_compass_nhm_posX", sb.CPlayer);
        if (!_nhm_posY) _nhm_posY         = CVar.GetCVar("uz_hhx_compass_nhm_posY", sb.CPlayer);
        if (!_nhm_scale) _nhm_scale       = CVar.GetCVar("uz_hhx_compass_nhm_scale", sb.CPlayer);

		// No Helmet
        if (!_nhm_bgRef) _nhm_bgRef       = CVar.GetCVar("uz_hhx_compass_bg_nhm_ref", sb.CPlayer);
        if (!_nhm_bgPosX) _nhm_bgPosX     = CVar.GetCVar("uz_hhx_compass_bg_nhm_posX", sb.CPlayer);
        if (!_nhm_bgPosY) _nhm_bgPosY     = CVar.GetCVar("uz_hhx_compass_bg_nhm_posY", sb.CPlayer);
        if (!_nhm_bgScale) _nhm_bgScale   = CVar.GetCVar("uz_hhx_compass_bg_nhm_scale", sb.CPlayer);
        if (!_hlm_bgRef) _hlm_bgRef       = CVar.GetCVar("uz_hhx_compass_bg_hlm_ref", sb.CPlayer);
        if (!_hlm_bgPosX) _hlm_bgPosX     = CVar.GetCVar("uz_hhx_compass_bg_hlm_posX", sb.CPlayer);
        if (!_hlm_bgPosY) _hlm_bgPosY     = CVar.GetCVar("uz_hhx_compass_bg_hlm_posY", sb.CPlayer);
        if (!_hlm_bgScale) _hlm_bgScale   = CVar.GetCVar("uz_hhx_compass_bg_hlm_scale", sb.CPlayer);

		// Check to see if the font object matches one from cvars. 
        string newFont = _font.GetString();
		
		// Make a new font object and override the old one if so.
        if (_prevFont != newFont) {
            let font = Font.FindFont(newFont);
            _hudFont = HUDFont.create(font ? font : Font.FindFont('NewSmallFont'));
            _prevFont = newFont;
        }
    }
	

    override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
        // Grab info for whether or not we're drawing. 
		bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);
        int  hudLevel  = hasHelmet ? _hlm_hudLevel.GetInt() : _nhm_hudLevel.GetInt();

		// See if we even have to draw. 
        if (
            !_enabled.GetBool()
            || (!hasHelmet && _hlm_required.GetBool())
            || HDSpectator(sb.hpl)
            || sb.HUDLevel < hudLevel
        ) return;
		// effectively an 'else' below.

        if (CheckCommonStuff(sb, state, ticFrac)) {


			// X and Y position on the Hud.
			// Technically can be helmet XY or nohelment XY.
            int   posX     = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
            int   posY     = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
			
			// These combine to form the overall hud element size. 
			//
			// Get the base size component.
			float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();
			// Get the size of the font.
			float fontScale = _fontScale.GetFloat();


			// Background element information. Technically can be two separate 'objects',
			// one for the helmet, one for no helmet. 
            string bgRef   = hasHelmet ? _hlm_bgRef.GetString()  : _nhm_bgRef.GetString();
            int    bgPosX  = hasHelmet ? _hlm_bgPosX.GetInt()    : _nhm_bgPosX.GetInt();
            int    bgPosY  = hasHelmet ? _hlm_bgPosY.GetInt()    : _nhm_bgPosY.GetInt();
            float  bgScale = hasHelmet ? _hlm_bgScale.GetFloat() : _nhm_bgScale.GetFloat();
			
			// Grab Unit Information
			int    units            = _units.GetInt();
			bool   Linebreaks       = _unitsLinebreak.GetBool();
			bool   ShowUnitDir      = _unitDir.GetBool();
			bool   ShowUnitSuffix   = _unitSuffix.GetBool();
			bool   ShowUnitXyz      = _unitXyz.GetBool();
			int    unitPrecision    = _unitPrecision.GetInt();
			int    unitRounding     = _unitRounding.GetInt();
            
			// For Printing Coords
			Array<string> lines;
			Vector2 lineoff = (0,0);
	
	
			/*
			// Get sanitized position.
			plPos.processStamp
			(
				sb.hpl.pos,
				units,
				unitRounding,
				unitPrecision,
				showUnitSuffix,
				showUnitDir,
				showUnitXyz,
				Linebreaks,
				',',
				' '
			);
			
			
			// Appends Position to the string.
			string posTxt = plPos.FetchPosString();

            // Draw HUD Element Background Image if it's defined
            sb.DrawImage(
                bgRef,
                (posX + bgPosX, posY + bgPosY),
                sb.DI_TOPLEFT,
                scale: (scale * bgScale, scale * bgScale)
            );

			
			// This should be dummied out into a static function for
			// drawing linebroken strings. How is this not a feature in
			// Gzdoom yet?
			if(Linebreaks)
			{
				// Offset for first line.
				lineoff.x = posX - (_hudFont.mFont.StringWidth(posTxt) >> 1);
				lineoff.y = posY + (_hudFont.mFont.GetHeight() * 6 * fontScale * scale ) + 6;
				
				// Split by linebreaks.
				posTxt.split(lines, "\n");

				// Go through each line.
				foreach(line : lines)
				{
					sb.DrawString(
						_hudFont,
						line,
						(lineoff.x, lineoff.y),
						translation: Font.CR_OLIVE,
						scale: (fontScale * scale, fontScale * scale)
					);
					
					// This 'breaks' the lines.
					lineoff.y += (_hudFont.mFont.GetHeight()* fontScale * scale);
				}
			}
            else
			{
				// Actually draw the position information. 
				sb.DrawString(
					_hudFont,
					posTxt,
					(posX - (_hudFont.mFont.StringWidth(posTxt) >> 1),
					posY + (_hudFont.mFont.GetHeight() * 6 * fontScale * scale ) + 6),
					translation: Font.CR_OLIVE,
					scale: (fontScale * scale, fontScale * scale)
				);
			}
			*/
        }
    }
}
