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
	[Marshall( field = "operator", field = "property", field = "activationValue" )]
	public class AchieveProperty
	{

		[Transient]
		public var activationValue : int;

		[Id]
		public var id : int;

		public var active : Boolean;

		[Transient]
		public var operator : String;

		public var owner_id : String;

		[Column( name = 'prop_id' )]
		public var propID : String;

		[Transient]
		public var property : String;

		public var value : int = 0;

		// you can use this for the as3 vanile reflection
		public function AchieveProperty( pOperator : String = "", pProperty : String = "", pActivationValue : Object = 0 )
		{
			operator = pOperator;
			property = pProperty;
			activationValue = parseInt( String( pActivationValue ) );
		}

		public function isActivated() : Boolean
		{
			return ( active == true );
		}

		public function isConditionMet() : Boolean
		{
			var result : Boolean = false;

			switch ( operator )
			{
				case AchieveManager.ACTIVE_IF_GREATER_THAN:
					result = value > activationValue;
					break;
				case AchieveManager.ACTIVE_IF_LESS_THAN:
					result = value < activationValue;
					break;
				case AchieveManager.ACTIVE_IF_EQUAL_TO:
					result = value == activationValue;
					break;
				case AchieveManager.ACTIVE_IF_NOT_EQUAL_TO:
					result = value != activationValue;
					break;
			}

			return result;
		}
	}
}
