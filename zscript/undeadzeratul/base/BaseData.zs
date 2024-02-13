/*==============================================================================
/ A "Universal" Datatype Base Class concept,
/ meant for complicated and related sets of information.
/-------------------------------------------------------------------------------
/ This Base Class assumes that Children will:
/
/ - Are interfaced with via the SetAll() function,
/  + SetAll() is implemented non virtually for all Children.
/
/ - Evaluate data deposited into them with the _Update() function,
/  + _Update() will contain calls to super.update() for Grandchildren.
/
/ - Utilize Get() and Set() functions for all member variables,
/  + this includes sets/gets that are done internally.
/
/ - Populate _init() with their preferred default values,
/  + _init() will contain calls to super._init() for Children.
/
==============================================================================*/

//
// Enumerators.  
//
// For Get...() functions that have multiple return types. 
enum UZGetValueTypes
{
	HHX_VALUE_RAW       = 0,
	HHX_VALUE_PROCESSED = 1
}



// Baseclass that holds and performs arithmetic on data. 
class UZBaseData abstract
{
//
// Member Variables. 
//

	// 'mutex' toggle. Makes processUpdate() only recalculate once.
	protected bool _Updating;

	// 'fail' toggle, acts like _Updating but has higher priority,
	// reset each time it's checked in processRecalculate().
	protected bool _Failed;
	
	// Whether or not this class initialized yet. 
	protected bool _HasInit;
	
	// Lets something interfacing with this class 'freeze' calculations,
	// this more or less disables updating until unfrozen.
	protected bool  _Frozen;
	
	// Lets something interfacing with this class 'lock' it's contents,
	// this more or less disables setting until unlocked.
	protected bool  _Frozen;

//
// Specialized member functions. 
//	
	
	// Locks or unLocks the class's data. 
	virtual void _SetLocked(bool newLocked)
	{
		self._checkInit();
		self._Locked = newLocked;
	}

	// Public facing version of _SetLocked(), for non-toggles. 
	void SetLocked(bool newFrozen)
	{
		self._Locked = self._SetLocked(newLocked);
	}
	
	// Public facing version of _SetLocked(), does what you'd expect. 
	void toggleLocked()
	{
		// true = false, false = true. 
		self._SetLocked(!(self._Locked));
	}

	
	// Freezes or unfreezes the class. 
	virtual void _SetFrozen(bool newFrozen)
	{
		self._checkInit();
		self._Frozen = newFrozen;
	}

	// Public facing version of _SetFrozen(), for non-toggles. 
	void SetFrozen(bool newFrozen)
	{
		self._Frozen = self._SetFrozen(newFrozen);
	}
	
	// Public facing version of _SetFrozen(), does what you'd expect. 
	void toggleFrozen()
	{
		// true = false, false = true. 
		self._SetFrozen(!(self._Frozen));
	}
	
	
	// Where default values should go. 
	virtual void _Init()
	{
		self._HasInit = true;
		self._Failed  = false;
		self._Frozen  = false;
		self._Locked  = false;
	}
	
	// For functions that look for whether or not something
	// needs initalized. 
	virtual void _checkInit()
	{
		// Init if the value(s) needed don't exist yet. 
		if(!(self._HasInit))
			self._Init();
	}

	// Public facing wrapper for _checkInit();
	void init()
	{
		self._checkInit();
	}
	

	// Whether or not a function(s) can set data.
	virtual bool _checkSet()
	{
		// can't be locked. 
		return !(self._Locked);
	}

	// Whether or not this object can process data.
	virtual bool _checkUpdate()
	{
		// can't be frozen, can't be updating. 
		return (!(self._Frozen)) && (!(self._Updating));
	}
	
		
	// Where the actual setting happens from SetAll(),
	// override this function and pass the parent's arguements to itself
	// first thing.
	abstract void _SetAll();
	
	// Where an end-user of this class calls _SetAll() and _UpdateAll(),
	// non-virtual since when this is overwritten, you reimplement all of it's
	// calls (SetAll() does not call super.SetAll()),
	//
	// Think of this as the head/start of the batch update routines. 
	abstract void SetAll();
	
	// The definition below is for reference only; it is to be implemented
	// by Children. 
	/*
	void SetAll
	(
	)
	{
	
		self._Updating = true;
	
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		
		// Pass to set method.
		if(self._checkSet())
			self._SetAll();
		
		self._Updating = false;
		
		// Pass to update method.
		if(self._checkUpdate())
			self._Update();
		
		
	}
	*/
	
	
	// Called whenever SetAll() finishes, 
	// calculates update info. 
	abstract void _Update();
	
	// Public facing wrapper for update();
	void update()
	{
		// Init if the value(s) needed don't exist yet. 
		self._checkInit();
		
		// Check if frozen.
		if(self._checkUpdate())
			return;
			
		// Actually update.
		self._Update();
	}
	
	// Called whenever Set..() finishes, (except SetAll()),
	// Mutex's set functions out of updating things,
	//
	// Different than update() since that function assumes a top level call,
	// this function assumes _init() resolved already. 
	virtual void _UpdateSingle()
	{			
		// Put this at the top of each override. It prevents
		// cascading during _SetAll().
		if(self._checkUpdate())
			return;
		
		// Recalculate everything. 
		self._Update();	
	}	
}
