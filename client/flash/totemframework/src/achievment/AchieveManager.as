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

package achievment
{

	public class AchieveManager
	{
		public static const ACTIVE_IF_GREATER_THAN : String = ">";

		public static const ACTIVE_IF_LESS_THAN : String = "<";

		private static var _instance : AchieveManager;

		public static function getInstance() : AchieveManager
		{
			return _instance ||= new AchieveManager( new SingletonEnforcer());
		}

		private var _achievements : Object;

		private var _props : Object;

		public function AchieveManager( enforcer : SingletonEnforcer )
		{

			if ( !enforcer )
			{
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );
			}
			_props = {};
			_achievements = {};
		}

		public function addValue( theProp : *, theValue : int ) : void
		{
			if ( theProp is String )
			{
				setValue( theProp, getValue( theProp ) + theValue );

			}
			else if ( theProp is Array )
			{
				for ( var i : int = 0; i < theProp.length; i++ )
				{
					setValue( theProp[ i ], getValue( theProp[ i ]) + theValue );
				}
			}
		}

		public function checkAchievements( theTags : Array = null ) : Vector.<Achievement>
		{
			var result : Vector.<Achievement> = null;

			for ( var n : String in _achievements )
			{
				var achivement : Achievement = _achievements[ n ];

				if ( achivement.unlocked == false )
				{
					var aActiveProps : int = 0;

					for ( var p : int = 0; p < achivement.props.length; p++ )
					{
						var aProp : Property = _props[ achivement.props[ p ]];

						if (( theTags == null || hasTag( aProp, theTags )) && aProp.isActive())
						{
							aActiveProps++;
						}
					}

					if ( aActiveProps == achivement.props.length )
					{
						achivement.unlocked = true;

						result = result || new Vector.<Achievement>;
						result.push( achivement );
					}
				}
			}

			return result;
		}

		public function defineAchievement( theName : String, relatedProps : Array ) : void
		{
			checkPropertyExists( relatedProps );
			_achievements[ theName ] = new Achievement( theName, relatedProps );
		}

		public function defineProperty( theName : String, theInitialValue : int, theaActivationMode : String, theValue : int, theTags : Array = null ) : void
		{
			_props[ theName ] = new Property( theName, theInitialValue, theaActivationMode, theValue, theTags );
		}

		public function dumpProperties() : String
		{
			var result : String = "";

			for ( var i : String in _props )
			{
				result += i + "=" + _props[ i ].value + ", ";
			}

			return result.substr( 0, result.length - 2 );
		}

		public function getValue( prop : String ) : int
		{
			checkPropertyExists( prop );
			return _props[ prop ].value;
		}

		public function resetProperties( theTags : Array = null ) : void
		{
			for ( var n : String in _props )
			{
				var aProp : Property = _props[ n ];

				if ( theTags == null || hasTag( aProp, theTags ))
				{
					aProp.reset();
				}
			}
		}

		public function setValue( theProp : *, theValue : int, theIgnoreActivationContraint : Boolean = false ) : void
		{
			if ( theProp is String )
			{
				doSetValue( theProp, theValue, theIgnoreActivationContraint );

			}
			else if ( theProp is Array )
			{
				for ( var i : int = 0; i < theProp.length; i++ )
				{
					doSetValue( theProp[ i ], getValue( theProp[ i ]) + theValue, theIgnoreActivationContraint );
				}
			}
		}

		private function checkPropertyExists( prop : * ) : void
		{
			var problematic : String = "";

			if ( prop is String )
			{
				if ( _props[ prop ] == null )
				{
					problematic = prop;
				}

			}
			else if ( prop is Array )
			{
				for ( var i : int = 0; i < prop.length; i++ )
				{
					if ( _props[ prop[ i ]] == null )
					{
						problematic = prop[ i ];
					}
				}
			}

			if ( problematic.length != 0 )
			{
				throw new ArgumentError( "Unknown achievement property \"" + problematic + "\". Check if it was correctly defined by defineProperty()." );
			}
		}

		private function doSetValue( theProp : String, theValue : int, theIgnoreActivationContraint : Boolean = false ) : void
		{
			checkPropertyExists( theProp );

			if ( !theIgnoreActivationContraint )
			{
				switch ( _props[ theProp ].activation )
				{
					case AchieveManager.ACTIVE_IF_GREATER_THAN:
						theValue = theValue > _props[ theProp ].value ? theValue : _props[ theProp ].value;
						break;
					case AchieveManager.ACTIVE_IF_LESS_THAN:
						theValue = theValue < _props[ theProp ].value ? theValue : _props[ theProp ].value;
						break;
				}
			}

			_props[ theProp ].value = theValue;
		}

		private function hasTag( theProp : Property, theTags : Array ) : Boolean
		{
			var result : Boolean = false;

			for ( var i : int = 0; i < theTags.length; i++ )
			{
				if ( theProp.tags != null && theProp.tags.indexOf( theTags[ i ]) != -1 )
				{
					result = true;
					break;
				}
			}

			return result;
		}
	}
}

class SingletonEnforcer
{
}
