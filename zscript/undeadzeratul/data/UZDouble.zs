//
// Enumerators.  
//

// Distance unit codes. 
enum UZDistanceUnits
{
	HHX_DIST_MAPUNITS   = 0,
	HHX_DIST_METERS     = 1,
	HHX_DIST_KILOMETERS = 2,
	HHX_DIST_MILES      = 3
}

// Precision accuracy codes.
enum UZPrecisionUnits
{
	HHX_PREC_INT    =  0,
	HHX_PREC_1      =  1,
	HHX_PREC_2      =  2,
	HHX_PREC_3      =  3,
	HHX_PREC_4      =  4,
	HHX_PREC_DOUBLE = -1
}

// Rounding mode codes. 
enum UZRoundingUnits
{
	HHX_ROUND_TRUNC  =  0,
	HHX_ROUND_NORMAL =  1,
	HHX_ROUND_CEIL   =  2,
	HHX_ROUND_FLOOR  =  3
}



// A double with various forms of trouble. 
class UZDouble : UZBaseData
{
//
// Member Variables. 
//
	// Raw Value
	private double  _Contents;
	// Math'd on value.
	private double  contents;
	
	private int     units;         // unit code to use for unit conversion,
	private bool    shouldConvert; // whether or not to convert _Contents to the code specified by units.
	private bool    shouldRound;   // whether or not to round this value down/up,
	private int     rounding;      // rounding mode (ceil, floor, normal),
	private int     precision;     // precision digit for rounding (0.1, 0.001, etc).
	
	

//
// Specialized Process/Fetch Functions. 
//

	// Where default values are set.
	override void _Init()
	{
		super._Init();
		self._Contents     = 0;
		self.units         = HHX_DIST_MAPUNITS;
		self.rounding      = HHX_ROUND_TRUNC;
		self.precision     = HHX_PREC_DOUBLE;
		self.shouldConvert = false;
		self.shouldRound   = false;
		self.contents      = 0;
		
	}
	
	// Called whenever SetAll() finishes, 
	// calculates update info. 
	override void _Update
	(
	)
	{
		self._processContents();
	}
	
	// Where the actual setting happens from SetAll(),
	// override this function and pass the parent's arguements to itself
	// first thing.
	override void _SetAll
	(
		double  _Contents,
		int     units,
		int     rounding,
		int     precision,
		bool    shouldConvert,
		bool    shouldRound
	)
	{
		// Replace old values,
		// could be made faster by not calling Get..() but this allows child classes to change
		// their parent class's get and set behaviors for SetAll, should they choose to - [FDA].
		if(_Contents     != self.GetContents(HHX_VALUE_RAW)) self.SetContents(_Contents);
		if(units         != self.GetUnits())                 self.SetUnits(units);		
		if(rounding      != self.GetRounding())              self.SetRounding(rounding);
		if(precision     != self.GetPrecision())             self.SetPrecision(precision);
		if(shouldConvert != self.GetConvertValue())          self.SetConvertValue(shouldConvert);
		if(shouldRound   != self.GetRoundValue())            self.GetRoundValue(shouldRound);
	}
	
	// Where an end-user of this class calls _SetAll() and _UpdateAll().
	void SetAll
	(
		double  _Contents,
		int     units,
		int     rounding,
		int     precision,
		bool    shouldConvert,
		bool    shouldRound
	)
	{
		
		self._Updating = true;
	
		// Init if the value(s) needed don't exist yet. 
		self.checkInit();
		
		// Pass to set method.
		self._SetAll
		(
			_Contents,
			units,
			rounding,
			precision,
			shouldConvert,
			shouldRound
		);
		
		// Pass to update method.
		if(self._checkUpdate())
			self._Update();
		
		self._Updating = false;
	}

	// Recalculates the non-raw double,
	// This involves a unit conversion + rounding. 
	virtual bool _processContents()
	{
		bool result = true;
	
		// First convert value to desired units.
		if(self.shouldConvert)
			self.contents = UZDouble.ConvertUnitsDouble(self._Contents, self.units);
		
		// Then round the converted vector.
		if(self.shouldRound)
			self.contents = UZDouble.RoundDouble(self.contents, self.rounding, self.precision);
		
		return result;
	}
	
	
//
// Get/Set functions.
//


// All Set...() functions call '_checkInit(), _UpdateSingle()', you cannot suppress this.
//
	// Change raw contents.
	virtual void SetContents(double newContents)
	{
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		self._Contents = newContents;
		self._UpdateSingle();
	}
	
	// Change unit code. 
	virtual void SetUnits(int newUnits)
	{
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		self.units = newUnits;
		self._UpdateSingle();
	}
	
	// Change rounding mode. 
	virtual void SetRounding(int newRounding)
	{
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		self.rounding = newRounding;
		self._UpdateSingle();
	}
	
	// Change double precision.
	virtual void SetPrecision(int newPrecision)
	{
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		self.precision = newPrecision;
		self._UpdateSingle();
	}

	// Change whether unit conversion is enabled. 
	virtual void SetConvertValue(bool newShouldConvert)
	{
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		self.shouldConvert = newShouldConvert;
		self._UpdateSingle();
	}

	// Change whether unit conversion is enabled. 
	virtual void SetRoundValue(bool newShouldRound)
	{
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		self.shouldRound = newShouldRound;
		self._UpdateSingle();
	}	
	
	
	// Fetch contents, supports returning the raw double when passed HHX_VALUE_RAW.
	virtual double GetContents(int type=HHX_VALUE_PROCESSED)
	{
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		
		double value = 0;
		
		switch(type)
		{
			case HHX_VALUE_RAW:
				value = self._Contents;
				break;
			
			case HHX_VALUE_PROCESSED:	
				value = self.contents;
				break;
				
			default:
				break;
		}
		
		return value;	
	}
	
	// Get current unit code. 
	virtual int GetUnits()
	{
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		return self.units;
	}

	// Get current rounding mode. 	
	virtual int GetRounding()
	{
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		return self.rounding;
	}

	// Get current double precision. 		
	virtual int GetPrecision()
	{
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		return self.precision;
	}
	
	// Get whether unit conversion is enabled. 
	virtual bool GetConvertValue()
	{
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		return self.shouldConvert;
	}
	
	// Get whether rounding output is enabled.
	virtual bool GetRoundValue()
	{
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		return self.shouldRound;
	}
	
	
	
//
// Statics/Utility Functions. 
//

	// Returns a rounded version of amount,
	// can be configured to not trim the lesser value(s) with cutExcess.
	static double RoundDouble(double number, int rounding, int precision)
	{
		// Set up our variables. 
		// This also translates rounding and precision codes into their math components.
		double value         = number;
		double roundingAdd   = UZDouble.getRoundingAddition(rounding);
		double precisionMult = UZDouble.getPrecisionMultiplier(precision);
		int    sign          = 0;
		
		// There's probably a way to extrapolate this otherwise, but 
		// this seems easiest. - [FDA]
		if(value < 0)
			sign = -1;
		else
			sign = 1;
		
		// Append the 'rounding' value.
		// If roundingAdd or precisionMult are 0 this does nothing. 
		value += ((roundingAdd * precisionMult) * sign);

		// Remove excess if desired.
		if(precisionMult != 0)
		{
			value = UZDouble.cutExcessDouble(value, precision);
		}
		
		// Return. 
		return value;
	}

	// Returns a trimmed/truncated version of number,
	// goes from least significant digit to 1.
	static double cutExcessDouble(double number, int precision)
	{
		double value = number;
		
		// Multipliers.
		int    valueMultCut  = UZDouble.getPrecisionMultiplier(precision, invert:true);
		double valueMultKeep = UZDouble.getPrecisionMultiplier(precision);

		// Since if value or mult are zero there's nothing to do here. 
		if(value == 0 || valueMultCut == 0 || valueMultKeep == 0)
			return value;

		value = floor(value * valueMultCut);
		value = value * valueMultKeep;

		
		return value;
	}
	
	// Returns a unit converted version of amount.
	static double ConvertUnitsDouble(double amount, int units)
	{
	
		// Return value (nulled since we always add something to it).
		double value;
		
		// Switch for what unit to use. 
        switch(units)
		{
			// Doom Map Units.
			default:                // Also the default case. 
			case HHX_DIST_MAPUNITS:
				value = amount;
				break;
			
			// Meters.
            case HHX_DIST_METERS:
				value = amount / HDCONST_ONEMETRE;
				break;
				
			// Kilometers.
            case HHX_DIST_KILOMETERS:
			
				value = (amount / HDCONST_ONEMETRE) * HDCONST_METERTOKILOMETER;
				break;
				
			// Miles.
            case HHX_DIST_MILES:
				value = (amount / HDCONST_ONEMETRE) * HDCONST_METERTOMILE;
				break;
        }
		
		return value;
	}
	
	// Translates a rounding code into a rounding value,
	// add this value to your number to 'round' that digit up. 
	static double getRoundingAddition(int rounding)
	{
		double value = 0;
		
		switch(rounding)
		{
			// Trucate
			default: // any nonvalid rounding code,
			case HHX_ROUND_TRUNC:  // vanilla
			case HHX_ROUND_FLOOR:  // 'round down',
				// Default behavior already truncates, we don't need to do anything.
				break;
				
			// Regular Rounding (down if smaller than 0.5, up if bigger than 0.5).
			case HHX_ROUND_NORMAL:
				// Adding 0.5 bumps values that would be > 0.5 up one place.
				value = 0.5;
				break;
			
			// Always Round Up.
			case HHX_ROUND_CEIL:
				// Adding 1 bumps all values up one place.
				value = 1;
				break;
			
		}
		
		return value;
	}

	// Translates a precision code into a multiplier,
	// Multiply this value by a rounding value to target smaller digits,
	// ^ when invert = false.
	//
	// Invert values are used for cutting certain portions of a double off,
	// ^ see CutExcessDouble() for implementation details. 
	static double getPrecisionMultiplier(int precision, bool invert=false)
	{
		double value;
		
		// Switch for precision.
		// 'invert' 
		switch(precision)
		{
			// No Precision / "cast as integer"
			Default:
			case HHX_PREC_INT:
				if(!invert)
					value = 1;
				else
					value = 1;
				break;
			
			// All Precision / "cast as double"
			case HHX_PREC_DOUBLE:
				if(!invert)
					value = 0;
				else
					value = 0;
				break;
			
			// +1 Precision.
			case HHX_PREC_1:
				if(!invert)
					value = 10;
				else
					value = 0.1;
				break;
				
			// +2 Precision.
			case HHX_PREC_2:
				if(!invert)
					value = 0.01;
				else
					value = 100;
				break;
				
			// +3 Precision.
			case HHX_PREC_3:
				if(!invert)
					value = 0.001;
				else
					value = 1000;
				break;
				
			// +4 Precision.
			case HHX_PREC_4:
				if(!invert)
					value = 0.0001;
				else
					value = 10000;
				break;
		}
		
		return value;
	}
}

