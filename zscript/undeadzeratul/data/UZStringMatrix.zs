//
// Enumerators.  
//
// For Get...() functions that have multiple return types. 
enum UZIndexCodes
{
	HHX_INDEX_ALL = -1
}



// An array of stringarrays (a string matrix).
class UZStringMatrix : UZBaseData
{
//
// Member Variables. 
//	

	
	private Array<UZStringArray> matrix;

	private int mode;
	
	// Amount of padding applied.
	// Won't be applied if length is smaller than the string(s),
	// Make zero to turn length into the max of contents[..].length(),
	// Make negative to length into the max of contents[..].length() + abs(length).
	private int length;
	
	// Holds this string's padding character.
	private string padding;

	// Direction padding is applied.
	private bool direction;
	


// Specialized Process/Fetch Functions. 
//	

	// Where default values should go. 
	override void init()
	{
		super.init();
	}

	void processStamp
	(
		int           index,     // index to use for writing it, -1 sets all.
		Array<string> _Contents, // string to write,
		int           mode,      // mode to write in,
		int           length,    // length for padding,
		string        padding,   // padding character,
		bool          direction  // padding direction.
	)
	{
		// Supress updates. 
		self._Updating = true;
		
		// Resume updates. 
		self._Updating = false;
	}

	// Lets you rubber stamp any info you want onto the class,
	// it will then process the results into useable data for you. 
	override void processUpdate()
	{
		// Follow this if template for new values.
		// if(contents  != self.GetContents(HHX_VALUE_RAW)) self.SetContents(contents);
		// Recalculate Contents
		self.processRecalculate();
	}
	
	
	// A function with '_process' as it's prefix should be called here,
	// to turn a raw value(s) + modifiers into a processed one(s).
	// Check for _Updating, if true, don't process anything.
	//
	// To check to see if a subclass updated successfully, evaluate the result
	// of super.processRecalculate().
	override bool processRecalculate()
	{	
		bool updated = self.processRecalculate();
		
		if(updated)
			self._processMatrix(self.index, self.content, self.mode, self.length, self.padding, self.direction);
		
		return updated;
	}
	
	// Edits matrices. 
	virtual void _processMatrix(int index, string content, int mode, int length, string padding, bool direction)
	{
		// Rewrite every single one if -1 is passed.
		if(index == HHX_INDEX_ALL)
		{
			for(int i = 0; i < self.matrix.size(); i++)
			{
				self.StampIndexContent(i, content, mode, length, padding, direction);
			}
		}
		else
		{
			self.StampIndexContent(index, content, mode, length, padding, direction);
		}
	}
	
	// We trust that the stamp function can deal with the value(s) we pass to it. 
	virtual void StampIndexContent(int index, string content, int mode, int length, string padding, bool direction)
	{
		self.matrix[index].processStamp(content, mode, length, padding, direction);
	}
	
	virtual string FetchIndexString(int index, string delimiter)
	{
		return self.matrix[index].FetchContentsAppended(delimiter);
	}
	
	virtual string FetchCompleteMatrix(int index, string delimiter)
	{
		// Accumulator for each string. 
		Array<UZStringArray> valueMatrix = UZStringArray(new('UZStringArray'));
		Array<string>        emptyValue  = {"", "", ""};
		valueMatrix.init();
		valueMatrix.SetContents(emptyValue, HHX_STRARR_SETCONT_REPLACE);
		
		return self.matrix[index].FetchContentsAppended(delimiter);
	}
}
