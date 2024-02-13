// Wrapper for UZPos3,
// Tracks and caches string formatting.
class UZStringPos3 : UZPos3
{
	// Replace this with a native 'make empty' function.
	private Array<string> arrEmpty;
	
	// This probably also can be dummied out. 
	private Array<string> arrXyz;

	// Pending being replaced with UZStringArray
	// then being dummied out into UZHUDStringPos3, or a class of a similar
	// name. Afterwards these will be replaced with constant enums that index
	// any given array.


	// Holds finished position string.
	private UZStringArray _Contents;

	// Holds numbers of the finished position string.
	private UZStringArray contents;
	
	// Holds the suffixes of the finished position string. 
	private UZStringArray contentsSuffixes;

	// Holds the cardinal directions of the finished position string. 
	private UZStringArray contentsDir;

	// Holds the (X), (Y), (Z) values of the finished position string. 
	private UZStringArray contentsXyz;


	// The format string for each value (IE, '%i').
	private string contentsFormat;
	
	// What breaks up each part of the string. 
	private string contentsDelimiter;

	// What pads part of the string. 
	private string contentsSpacing;

	private bool showUnits;
	private bool showUnitDir;
	private bool showUnitXyz;
	private bool linebreaks;

	bool dumped;

	// Where default values are set.
	override void init()
	{
		super.init();
		
		arrEmpty.Push("");
		arrEmpty.Push("");
		arrEmpty.Push("");
		
		arrXyz.push("X");
		arrXyz.push("Y");
		arrXyz.push("Z");
		
		self._Contents         = UZStringArray(new('UZStringArray'));
		self.contents          = UZStringArray(new('UZStringArray'));
		self.contentsSuffixes  = UZStringArray(new('UZStringArray'));
		self.contentsDir       = UZStringArray(new('UZStringArray'));
		self.contentsXyz       = UZStringArray(new('UZStringArray'));
		self.contentsFormat    = "%i";
		self.contentsDelimiter = ",";
		self.contentsSpacing   = " ";
		self.showUnits         = false;
		self.showUnitDir       = false;
		self.showUnitXyz       = false;
		self.linebreaks        = false;

		// Set up each array.
		self._Contents.processStamp
		(
			self.arrEmpty,
			HHX_STRARR_SETCONT_REPLACE,
			HHX_STRARR_LENGTH,
			self.contentsSpacing,
			HHX_STRARR_LEFT
		);

		self.contents.processStamp
		(
			self.arrEmpty,
			HHX_STRARR_SETCONT_REPLACE,
			HHX_STRARR_LENGTH,
			self.contentsSpacing,
			HHX_STRARR_LEFT
		);

		self.contentsSuffixes.processStamp
		(
			self.arrEmpty,
			HHX_STRARR_SETCONT_REPLACE,
			HHX_STRARR_LENGTH,
			self.contentsSpacing,
			HHX_STRARR_LEFT
		);

		self.contentsDir.processStamp
		(
			self.arrEmpty,
			HHX_STRARR_SETCONT_REPLACE,
			HHX_STRARR_LENGTH,
			self.contentsSpacing,
			HHX_STRARR_LEFT
		);
	
		self.contentsXyz.processStamp
		(
			self.arrXyz,
			HHX_STRARR_SETCONT_REPLACE,
			HHX_STRARR_LENGTHPLUSONE,
			self.contentsSpacing,
			HHX_STRARR_LEFT
		);
	}

	// Lets you rubber stamp any info you want onto the class,
	// it will then process the results into useable data for you. 
	void processStamp
	(
		Vector3 pos,
		int     units,
		int     rounding,
		int     precision,
		bool    showUnits,
		bool    showUnitDir,
		bool    showUnitXyz,
		bool    linebreaks,
		string  contentsDelimiter,
		string  contentsSpacing
	)
	{
		super.processStamp(pos, units, rounding, precision, false);

		self._Updating = true;
		
		// Replace old values.
		if(showUnits         != self.GetShowUnits())         self.SetShowUnits(showUnits);
		if(showUnitDir       != self.GetShowUnitDir())       self.SetShowUnitDir(showUnitDir);
		if(showUnitXyz       != self.GetShowUnitXyz())       self.SetShowUnitXyz(showUnitXyz);
		if(linebreaks        != self.GetLinebreaks())        self.SetLinebreaks(linebreaks);
		if(contentsDelimiter != self.GetContentsDelimiter()) self.SetContentsDelimiter(contentsDelimiter);
		if(contentsSpacing   != self.GetContentsSpacing())   self.SetContentsSpacing(contentsSpacing);
		
		self._Updating = false;
		
		self.processUpdate();
	}

	// Get sanitized position.
	override void processUpdate()
	{
		if(!(self._Updating))
			self.processRecalculate();
	}
	
	override bool processRecalculate()
	{
		bool parentsRecalculated = super.processRecalculate();
		// If your calculation(s) can fail or need other criteria, 
		// && the result to parentsRecalculated.
		if(parentsRecalculated)
			self._processPos();
		
		
		return parentsRecalculated;
	}
	
	override bool _processPos()
	{
		bool result = super._processPos();
		
		if(result)
			result = result && (self._processContents());
			
		return result;
	}
	
	virtual bool _processContents()
	{
		bool          result      = true;

		// So each section of numbers has it's own seperator.
		Array<string> arrValueDelimiter;
		arrValueDelimiter.push(self.contentsSpacing);
		arrValueDelimiter.push(self.contentsSpacing);
		arrValueDelimiter.push(self.contentsSpacing);


		// Because of how Zscript handles dynamic arrays we need to pass in 
		// a generic pointer and clear it after each assignment. 
		Array<string> functionVal;

		// Format output string components.
		//

		// Process position.
		self.contentsFormat = self.GetPrecisionString(self.GetPrecision());
		self.GetPosArray(functionVal, self.GetPos(), self.contentsFormat); 
		// Write position.
		self.contents.processStamp
		(
			functionVal,
			HHX_STRARR_SETCONT_REPLACE,
			HHX_STRARR_LENGTHPLUSONE,
			self.contentsSpacing,
			HHX_STRARR_RIGHT
		);
		self.contents.SetContents(arrValueDelimiter, HHX_STRARR_SETCONT_CONCAT);
		functionVal.Clear();


		// Format Direction strings.
		self.GetDirArray(functionVal, self.GetPos(), self.GetUnits());
		// Write Direction strings.
		self.contentsDir.processStamp
		(
			functionVal,
			HHX_STRARR_SETCONT_REPLACE,
			HHX_STRARR_LENGTHPLUSONE,
			self.contentsSpacing,
			HHX_STRARR_LEFT
		);
		self.contentsDir.SetContents(arrValueDelimiter, HHX_STRARR_SETCONT_CONCAT);
		functionVal.Clear();


		// Format suffix strings.
		self.GetUnitArray(functionVal, self.GetUnits());
		// Write suffix strings.
		self.contentsSuffixes.processStamp
		(
			functionVal,
			HHX_STRARR_SETCONT_REPLACE,
			HHX_STRARR_LENGTHPLUSONE,
			self.contentsSpacing,
			HHX_STRARR_LEFT
		);
		self.contentsSuffixes.SetContents(arrValueDelimiter, HHX_STRARR_SETCONT_CONCAT);
		functionVal.Clear();
		
		
		// Format/Write XYZ strings.
		// We don't need a full stamp for this, the string never changes.
		// Write suffix strings.
		self.contentsXyz.processStamp
		(
			self.arrXyz,
			HHX_STRARR_SETCONT_REPLACE,
			HHX_STRARR_LENGTHPLUSONE,
			self.contentsSpacing,
			HHX_STRARR_LEFT
		);
		self.contentsXyz.SetContents(arrValueDelimiter, HHX_STRARR_SETCONT_CONCAT);

		// Prepare output string (clears previous contents). 
		self._Contents.processStamp
		(
			self.arrEmpty,
			HHX_STRARR_SETCONT_REPLACE,
			HHX_STRARR_LENGTHPLUSONE,
			self.contentsSpacing,
			HHX_STRARR_LEFT
		);


		// Build output string. 
		//
		
		// Append Position.
		self._Contents.SetContents(self.contents.contents, HHX_STRARR_SETCONT_CONCAT);
		
		// Append Direction
		if(self.showUnitDir)
			self._Contents.SetContents(self.contentsDir.contents, HHX_STRARR_SETCONT_CONCAT);
		
		// Append XYZ
		if(self.showUnitXyz)
			self._Contents.SetContents(self.contentsXyz.contents, HHX_STRARR_SETCONT_CONCAT);
		
		// Append Units
		if(self.showUnits)
			self._Contents.SetContents(self.contentsSuffixes.contents, HHX_STRARR_SETCONT_CONCAT);
		

		
		return result;
	}
	
	virtual string FetchPosString()
	{
		string fullDelimiter = self.contentsDelimiter;
		
		if(self.linebreaks)
			fullDelimiter = fullDelimiter.."\n";
			
		return self._Contents.FetchContentsAppended(fullDelimiter);
	}


//
// Get/Set functions.
//

// All Set...() functions call 'processRecalculate()', you cannot suppress this.
//
	
	
	virtual void SetContentsDelimiter(string newContentsDelimiter)
	{
		self.contentsDelimiter = newContentsDelimiter;

		self.processRecalculate();
	}

	virtual void SetContentsSpacing(string newContentsSpacing)
	{
		self.contentsSpacing = newContentsSpacing;

		self.processRecalculate();
	}
	
	virtual void SetShowUnits(bool newShowUnits)
	{
		self.showUnits = newShowUnits;

		self.processRecalculate();
	}
	
	virtual void SetShowUnitDir(bool newShowUnitDir)
	{
		self.showUnitDir = newShowUnitDir;
		
		self.processRecalculate();
	}
	
	virtual void SetShowUnitXyz(bool newShowUnitXyz)
	{
		self.showUnitXyz = newShowUnitXyz;
		
		self.processRecalculate();
	}
	
	virtual void SetLinebreaks(bool newLinebreaks)
	{
		self.linebreaks = newLinebreaks;
		
		self.processRecalculate();
	}
	
	virtual bool GetShowUnits()
	{
		return self.showUnits;
	}
	
	virtual bool GetShowUnitDir()
	{
		return self.showUnitDir;
	}
	
	virtual bool GetShowUnitXyz()
	{
		return self.showUnitXyz;
	}
	
	virtual bool GetLinebreaks()
	{
		return self.linebreaks;
	}
	
	virtual string GetContentsDelimiter()
	{
		return self.contentsDelimiter;
	}

	virtual string GetContentsSpacing()
	{
		return self.contentsSpacing;
	}
	
	
	
//
// Statics/Utility Functions. 
//

	virtual void GetDirArray(Array<string> value, Vector3 pos, int units)
	{
		// Min values for 'center' threshold.
		double centerMin = UZDouble.ConvertUnitsDouble(-1, units);
		double centerMax = UZDouble.ConvertUnitsDouble( 1, units);
		
		// Control Bools for Direction. Named for ease of use (only calc if needed).
		// 0 = back/south, 1 = forward/north
		bool posXdir;
		// 0 = left/west, 1 = right/east
		bool posYdir;
		// 0 = down, 1 = up
		bool posZdir;
		
		// For if you're in the center of any given plane (or flat on the ground (sea level?)).
		bool posXcenter;
		bool posYcenter;
		bool posZflat;
		
		// If you're in a direction.
		posXdir  = (pos.x < 0);
		posYdir  = (pos.y < 0);
		posZdir  = (pos.z < 0);
		
		// If you're in the center of a plane.
		// The tollerance should depend on the unit you use (miles are longer, etc).
		posXcenter = (pos.x <= centerMax) && (pos.x >= centerMin);
		posYcenter = (pos.y <= centerMax) && (pos.y >= centerMin);
		posZflat   = (pos.z <= centerMax) && (pos.z >= centerMin);
		
		// Build X
		if(!posXcenter)
			value.push(posXdir ? "West" : "East");
		else
			value.push("Center");
		
		// Build Y
		if(!posYcenter)		
			value.push(posYdir ? "South"  : "North");
		else
			value.push("Center");
		
		// Build Z
		if(!posZflat)
			value.push(posZdir ? "Down" : "Up");
		else
			value.push("Level");
	}
	
	virtual void GetUnitArray(Array<string> value, int units)
	{
		value.push("");
		value.push("");
		value.push(UZStringPos3.GetUnitName(units));
	}

	virtual void GetPosArray(Array<string> value, Vector3 pos, string formatStr)
	{

		value.push(string.format(formatStr, pos.x));
		value.push(string.format(formatStr, pos.y));
		value.push(string.format(formatStr, pos.z));
	}

	static string GetPrecisionString(int precision)
	{
		string value;
		int    valuePrecision = 0;
		
		// Determine precision.
		switch(precision)
		{
			// No Precision / "cast as integer"
			Default:
			case HHX_PREC_INT:
				value = "%i";
				break;
			
			// All Precision / "cast as double"
			case HHX_PREC_DOUBLE:
				value = "%f";
				break;
			
			// +1 Precision.
			case HHX_PREC_1:
				valuePrecision = 1;
				break;
				
			// +2 Precision.
			case HHX_PREC_2:
				valuePrecision = 2;
				break;
				
			// +3 Precision.
			case HHX_PREC_3:
				valuePrecision = 3;
				break;
				
			// +4 Precision.
			case HHX_PREC_4:
				valuePrecision = 4;
				break;
		}
		
		// Add precision if specified.
		if(valuePrecision)
		{
			value = "%."..valuePrecision.."f";
		}
		
		// Return value.
		return value;
	}
	
	// Get Unit English Name. 
	static string GetUnitName(int units)
	{
		string value;
		
		// Units Switch.
		// Can probably be replaced with an array we instantiate on worldload
		// that translates unit strings. That'd save some comparisons each tick.
		switch(units)
		{
			// units = "mu/s";
			// Doom Map Units.
			default:
			Case HHX_DIST_MAPUNITS:
				value = "Map Units";
				break;
		
			//units = "Metres";
			case HHX_DIST_METERS:
				value = "Meters";
				break;
				
			// units = "km/h";
			// Kilometers.
			case HHX_DIST_KILOMETERS:
				value = "Kilometers";
				break;
				
			// units = "mph";
			// Miles.
			case HHX_DIST_MILES:
				value = "Miles";
				break;		
		}
		
		// Return value.
		return value;
	}
}


