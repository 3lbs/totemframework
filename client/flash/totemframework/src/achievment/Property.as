//------------------------------------------------------------------------------
//
//     _______ __ __           
//    |   _   |  |  |--.-----. 
//    |___|   |  |  _  |__ --| 
//     _(__   |__|_____|_____| 
//    |:  1   |                
//    |::.. . |                
//    `-------'      
//                       
//   3lbs Copyright 2013 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package achievment
{

	/**
	 * Describes a property used to measure an achievement progress. A property is pretty much a counter
	 * with some special attributes (such as default value and update constraints).
	 */
	public class Property
	{
		private var _activation : String;

		private var _activationValue : int;

		private var _initialValue : int;

		private var _name : String;

		private var _tags : Array;

		private var _value : int;

		public function Property( theName : String, theInitialValue : int, theActivation : String, theActivationValue : int, theTags : Array = null )
		{
			_name = theName;
			_activation = theActivation;
			_activationValue = theActivationValue;
			_initialValue = theInitialValue;
			_tags = theTags;

			reset();
		}

		public function get activation() : String
		{
			return _activation;
		}

		public function isActive() : Boolean
		{
			var result : Boolean = false;

			switch ( _activation )
			{
				case AchieveManager.ACTIVE_IF_GREATER_THAN:
					result = _value > _activationValue;
					break;
				case AchieveManager.ACTIVE_IF_LESS_THAN:
					result = _value < _activationValue;
					break;
			}

			return result;
		}

		public function get name() : String
		{
			return _name;
		}

		public function reset() : void
		{
			_value = _initialValue;
		}

		public function get tags() : Array
		{
			return _tags;
		}

		public function get value() : int
		{
			return _value;
		}

		public function set value( v : int ) : void
		{
			_value = v;
		}
	}
}
