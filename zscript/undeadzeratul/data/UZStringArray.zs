//
// Enumerators.  
//

// For use with SetContents(),
// determines the array-combination mode.
enum UZStrArrSetContents
{
	HHX_STRARR_SETCONT_REPLACE       = 0, // replace old with new,
	HHX_STRARR_SETCONT_OVERLAY       = 1, // overlay new onto old, 
	HHX_STRARR_SETCONT_CONCAT        = 2, // overlay new onto old, append new to old.
	HHX_STRARR_SETCONT_INSERT        = 3, // insert new at the front of old,
	HHX_STRARR_SETCONT_PUSH          = 4  // append new at the end of old.  
}

// For use with JustifyContents(),
// determines the justification length. 
enum UZStrArrJustifyContents
{
	HHX_STRARR_LENGTH        =  0,
	HHX_STRARR_LENGTHPLUSONE = -1 // Any negative value adds to length() after it's found.
}

	
// For use with functions that alter strings,
// determines the direction to index from/append to. 
enum UZStrArrIndexString
{
	HHX_STRARR_LEFT  = 1,
	HHX_STRARR_RIGHT = 0
}

// String array that allows for batch execution/directly comparing string properties. 
class UZStringArray : UZBaseData
{
//
// Member Variables. 
//	

	// Holds raw strings.
	private Array<string> _Contents;
	
	// Holds processed strings.
	Array<string> contents;
	
	// Holds this string's padding character.
	private string padding;

	// Amount of padding applied.
	// Won't be applied if length is smaller than the string(s),
	// Make zero to turn length into the max of contents[..].length(),
	// Make negative to length into the max of contents[..].length() + abs(length).
	private int length;
	
	// Direction padding is applied.
	private bool direction;


//
// Specialized Process/Fetch Functions. 
//

	// Where default values are set.
	override void init()
	{
		super.init();
		self.padding   = " ";
		self.length    = HHX_STRARR_LENGTH;
		self.direction = HHX_STRARR_LEFT;
	}

	// Lets you rubber stamp any info you want onto the class,
	// it will then process the results into useable data for you. 
	void processStamp
	(
		Array<string> _Contents,
		int           mode,
		int           length,
		string        padding,
		bool          direction,
		bool          shouldRecalc=true
	)
	{
		
		// Supress updates. 
		self._Updating = true;
		
		// Replace old values.
		if(_Contents && (_Contents != self._Contents))      self.SetContents(_Contents, mode);
		if(length    && (length    != self.GetLength()))    self.SetLength(length);	
		if(padding   && (padding   != self.GetPadding()))   self.SetPadding(padding);
		if(direction && (direction != self.GetDirection())) self.SetDirection(direction);		
		
		// Resume updates. 
		self._Updating = false;

		if(shouldRecalc)
			self.processUpdate();
	}

	// Lets you rubber stamp any info you want onto the class,
	// it will then process the results into useable data for you. 
	override void processUpdate()
	{
		// Recalculate string formatting.
		if(!(self._Updating))
			self.processRecalculate();
	}

	// Wrapper for _processContents().
	override bool processRecalculate()
	{
		bool parentsRecalculated = super.processRecalculate();
		
		// If your calculation(s) can fail or need other criteria, 
		// && the result to parentsRecalculated.
		if(parentsRecalculated)
			self._processContents(self.padding, self.length, self.direction);
		
		return parentsRecalculated;
	}

	// Justifies the entire string array using new contents. This can be recalculated as needed.  
	virtual bool _processContents(string padding, int length, bool direction)
	{
		bool result = true;
		
		// Justify and clone internal contents into external contents. 
		if(self._Contents.size() > 0)
		{
			self.contents.clear();
			self.JustifyStrings(self.contents, self._Contents, padding, length, direction);
		}
		else
		{
			result = false;
		}
		
		return result;
	}

	// Fetches the entire processed content array, combined with a delimiter. 
	virtual string FetchContentsAppended(string delimiter = "")
	{
		string result = "";
		
		for(int i = 0; i < self.contents.size(); i++)
		{
			result = result..self.contents[i];
			
			if(i+1 < self.contents.size())
				result = result..delimiter;
		}
		
		return result;
	}

	// Fetches a specific index of either the processed or unprocessed string arrays.
	virtual string FetchIndex(int index, int type)
	{
		string result = "";
		
		switch(type)
		{
			case HHX_VALUE_RAW:
				result = self._Contents[index];
				break;
				
			case HHX_VALUE_PROCESSED:
				result = self.contents[index];
				break;
		}
		
		return result;
	}



//
// Get/Set functions.
//

// All Set...() functions call 'processRecalculate()', you cannot suppress this.
//

	// Return contents array(s), supports returning the raw position when passed HHX_VALUE_RAW.
	/*
	virtual Array<string> GetContents(int type)
	{
		Array<string> value;
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
	*/
	
	// Gets the current padding character. 
	virtual string GetPadding()
	{
		return self.padding;
	}
	
	// Gets the current padding character. 
	virtual bool GetDirection()
	{
		return self.direction;
	}

	// Gets the current padding length. 
	virtual int GetLength()
	{
		return self.length;
	}
	
	
	// Assign new contents array. Supports various modes of transposition/insertion,
	// See Enumerators->UZStrArrSetContents for details.
	virtual void SetContents(Array<string> newContents, int mode=HHX_STRARR_SETCONT_REPLACE)
	{
		// Combine differently based on mode. 
		switch(mode)
		{
			// Completely trash the old array.
			case HHX_STRARR_SETCONT_REPLACE:
				self._Contents.Clear();
				UZStringArray.CopyPreserve(self._Contents, newContents);
				break;
			
			// Overlay new contents onto old contents.
			case HHX_STRARR_SETCONT_OVERLAY:
				for(int i = 0; i < newContents.size(); i++)
				{
					if(i < self._Contents.size())
					{
						self._Contents[i] = newContents[i];
					}
					else
					{
						self._Contents.push(newContents[i]);
					}
				}
				break;

			// Overlay new contents onto old contents, append new contents to old contents.
			case HHX_STRARR_SETCONT_CONCAT:
				for(int i = 0; i < newContents.size(); i++)
				{
					if(i < self._Contents.size())
					{
						if(!(self._Contents[i] == ''))
							self._Contents[i] = Contents[i]..newContents[i];
						else
							self._Contents[i] = newContents[i];
					}
					else
					{
						self._Contents.push(newContents[i]);
					}
				}
				break;

			// Inserts new contents to the front of the array. 		
			case HHX_STRARR_SETCONT_INSERT:
				for(int i = 0; i < newContents.size(); i++)
				{
					self._Contents.Insert(0, newContents[i]);
				}
				break;

			// Pushes new contents into the back of the array. 
			case HHX_STRARR_SETCONT_PUSH:
				for(int i = 0; i < newContents.size(); i++)
				{
					self._Contents.Push(newContents[i]);
				}
				break;
			
			// Raise an error. 
			default:
				console.printf("[HHX][ERROR] Invalid integer code '"..mode.."' used for instance of '"..self.getclassname().."' while calling setContents(). Please report this error to the mod author responsible.");
				self._Failed = true;
				break;
		}
		
		self.processRecalculate();
	}

	// Assigns a new padding character. 
	virtual void SetPadding(string newPadding)
	{
		self.padding = newPadding;

		self.processRecalculate();
	}

	// Sets the current padding direction.
	virtual void SetDirection(bool newDirection)
	{
		self.direction = newDirection;
		
		self.processRecalculate();
	}

	// Sets the current padding length. 
	virtual void SetLength(int newLength)
	{
		self.length = newLength;
	
		self.processRecalculate();
	}


//
// Statics/Utility Functions. 
//

	// Justifies a set of strings in one direction or another.
	// Automatically calculates length if default arguements are used. 
	// direction true  = left  justify,
	// direction false = right justify. 
	virtual void JustifyStrings(Array<string> value, Array<string> str_array, string padding, int length=-1, bool direction=HHX_STRARR_LEFT)
	{
		
		// So this function is still static, we need to do this. 
		int length_code = length;
		int length_acc  = 0;
		
		// Check to see if a length was given.
		// Zero is invalid so it's better to check for it too.
		if(length_code <= HHX_STRARR_LENGTH)
		{
			// If no length, calculate max length of a string in the array. 
			for(int i = 0; i < str_array.size(); i++)
			{
				if(length_acc < str_array[i].CodePointCount())
					length_acc = str_array[i].CodePointCount();
			}
			
			// Add negative portion (if any).
			length_acc += (length_code * -1);
		}
		
		// pad each string to justify them.
		for(int i = 0; i < str_array.size(); i++)
		{
			value.push(UZStringArray.padString(str_array[i], padding, length_acc, direction));
		}
		
	}
	
	// Pads a single string by appending characters to the left or right.
	static string padString(string str, string padding, int length, bool direction)
	{
		// Copy input string. 
		string value = str;
				
		// Append whitespace until meeting length.
		while(value.CodePointCount() < length)
		{
			value = direction ? padding..value : value..padding;
		}
			
		return value;
	}
	
	// Shaves the length of a string.
	// This is a method since it's more intuitive to shave off of a string
	// than grab a substring, I think, in some contexts. - [FDA]
	static string trimString(string str, int length, bool direction)
	{
		// Holder for input string. 
		string value = "";
		
		// Return an empty string if length is too large. 
		if(length >= str.CodePointCount())
		{
			return value;
		}
		// Return the whole string if nothing is to be cut.
		// Negative contents 'could' add padding instead, but I'm not a fan of that conceptually.  - [FDA]
		else if(length <= 0)
		{
			value = str;
			return value;
		}
		
		// Loop control. 
		bool finished = false;
		
		// Arguements for mid() that give the substring we and to return,
		// changes depending on the direction given.
		
		//              Cuts from the right                       :Cuts from the left,
		//              (string)trimmed                           :trimmed(string).
		int start     = direction ? 0                             : length;
		int end       = direction ? str.CodePointCount() - length : str.CodePointCount();


		// Grab the substring using mid();
		value = str.mid(start, end);
		
		return value;
	}
	
	static void CopyPreserve(Array<string> target, Array<string> value)
	{
		for(int i = 0; i < value.size(); i++)
		{
			target.Push(value[i]);
		}
	}
}