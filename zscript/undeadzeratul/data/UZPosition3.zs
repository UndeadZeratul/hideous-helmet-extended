// Vector 3 with position info,
// Not a child of UZDouble since there would be unused member variables otherwise.
class UZPos3 : UZBaseData
{
//
// Member Variables. 
//
	// Raw Position.
	private Vector3 _Pos;
	
	// Math'd on position.
	private Vector3 pos;
	
	// Toggles and switches. 
	private int     units;         // unit code to use for unit conversion,
	private bool    shouldConvert; // whether or not to convert _Pos to the code specified by units.
	private bool    shouldRound;   // whether or not to round this value down/up,
	private int     rounding;      // rounding mode (ceil, floor, normal),
	private int     precision;     // precision digit for rounding (0.1, 0.001, etc).
	
	
	
//
// Specialized Process/Fetch Functions. 
//

	// Where default values are set.
	override void init()
	{
		super.init();
		self._Pos          = (0, 0, 0);
		self.units         = HHX_DIST_MAPUNITS;
		self.rounding      = HHX_ROUND_TRUNC;
		self.precision     = HHX_PREC_DOUBLE;
		self.shouldConvert = false;
		self.shouldRound   = false;
		self.pos           = (0, 0, 0);
	}

	// Called whenever SetAll() finishes, 
	// calculates update info. 
	override void _Update()
	{
		self._processPos();
	}

	// Where the actual setting happens from SetAll(),
	// override this function and pass the parent's arguements to itself
	// first thing.
	override void _SetAll
	(
		Vector3 _Pos,
		int     units,
		int     rounding,
		int     precision,
		bool    shouldConvert,
		bool    shouldRound
	)
	{
		// Replace old values.
		if(_Pos          != self.GetPos(HHX_VALUE_RAW)) self.SetPos(_Pos);
		if(units         != self.GetUnits())            self.SetUnits(units);		
		if(rounding      != self.GetRounding())         self.SetRounding(rounding);
		if(precision     != self.GetPrecision())        self.SetPrecision(precision);
		if(shouldConvert != self.GetConvertValue())     self.SetConvertValue(shouldConvert);
		if(shouldRound   != self.GetRoundValue())       self.GetRoundValue(shouldRound);	
	}
	
	// Where an end-user of this class calls _SetAll() and _UpdateAll(),
	// non-virtual since when this is overwritten, you reimplement all of it's
	// calls (SetAll() does not call super.SetAll()),
	//
	// Think of this as the head/start of the batch update routines. 
	void SetAll
	(
		Vector3 _Pos,
		int     units,
		int     rounding,
		int     precision,
		bool    shouldConvert,
		bool    shouldRound
	)
	{
	
		self.Updating = true;
	
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		
		// Pass to set method.
		self._SetAll();
		
		// Pass to update method.
		self._Update();
		
		self.Updating = false;
	}
	
	// Recalculates the non-raw position,
	// This involves a unit conversion + rounding. 
	virtual bool _processPos()
	{
		bool result = true;
		
		// First convert value to desired units.
		if(self.shouldConvert)
			self.pos    = UZPos3.convertUnitsVector3(self._Pos, self.units);
		
		// Then round the converted vector.
		if(self.shouldRound)
			self.pos    = UZPos3.roundVector3(self.pos, self.rounding, self.precision);
		
		return result;
	}
	
	
//
// Get/Set functions.
//

// All Set...() functions call 'processRecalculate()', you cannot suppress this.
//

	// Change raw position.
	virtual void SetPos(Vector3 newPos)
	{
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		self._Pos = newPos;
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


	// Fetch position, supports returning the raw position when passed HHX_VALUE_RAW.
	virtual Vector3 GetPos(int type=HHX_VALUE_PROCESSED)
	{
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		
		Vector3 value;
		
		switch(type)
		{
			case HHX_VALUE_RAW:
				value = self._Pos;
				break;
			
			case HHX_VALUE_PROCESSED:
				value = self.pos;
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
	
	// Get current rounding code.
	virtual int GetRounding()
	{
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		return self.rounding;
	}
	
	// Get current precision. 
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

	// Returns a unit converted version of position.
	// Uses UZDouble's conversion function for each component. 
	static Vector3 convertUnitsVector3(Vector3 position, int units)
	{
	
		// Return value (nulled since we always add something to it).
		Vector3 value;
		
		// Convert each component
		value.x = UZDouble.convertUnitsDouble(position.x, units);
		value.y = UZDouble.convertUnitsDouble(position.y, units);
		value.z = UZDouble.convertUnitsDouble(position.z, units);
		
		// Return the value.
		return value;
	}
	
	// Returns a rounded version of position.
	// Uses UZDouble's rounding function for each component. 
	static Vector3 roundVector3(Vector3 position, int rounding, int precision)
	{
		// Return value (nulled since we always add something to it).
		Vector3 value;
		
		// Convert each component
		value.x = UZDouble.roundDouble(position.x, rounding, precision);
		value.y = UZDouble.roundDouble(position.y, rounding, precision);
		value.z = UZDouble.roundDouble(position.z, rounding, precision);
		
		// Return the value.
		return value;
	}
}


