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
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package achievements
{

	/**
	 * Describes a property used to measure an achievement progress. A property is pretty much a counter
	 * with some special attributes (such as default value and update constraints).
	 */
	[Bindable]
	public class AchieveProperty
	{

		public var _activationValue : int;

		[Transient]
		public var activation : String = AchieveManager.ACTIVE_IF_LESS_THAN;

		[Id]
		public var id : int;

		public var initialValue : int;

		// name of prop or event
		public var name : String;

		[Marshall( field = "id" )]
		public var propID : String;

		public var value : int;

		public function AchieveProperty( theActivationValue : int = 0, theTags : Array = null )
		{
			_activationValue = theActivationValue;

			reset();
		}

		public function isActive() : Boolean
		{
			var result : Boolean = false;

			switch ( activation )
			{
				case AchieveManager.ACTIVE_IF_GREATER_THAN:
					result = value > _activationValue;
					break;
				case AchieveManager.ACTIVE_IF_LESS_THAN:
					result = value < _activationValue;
					break;
			}

			return result;
		}

		public function reset() : void
		{
			value = initialValue;
		}

		[Marshall( field = "activation" )]
		public function setActivation( value : String ) : void
		{
			activation = value;
		}
	}
}
