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

	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.utils.Dictionary;

	import totem.events.RemovableEventDispatcher;

	public class AchieveManager extends RemovableEventDispatcher
	{
		public static const ACTIVE_IF_GREATER_THAN : String = ">";

		public static const ACTIVE_IF_LESS_THAN : String = "<";

		private static var _instance : AchieveManager;

		public static function getInstance() : AchieveManager
		{
			return _instance ||= new AchieveManager( new SingletonEnforcer());
		}

		private var _achievements : AchievementObject;

		private var _initialized : Boolean;

		private var _props : Dictionary;

		private var dispatcher : IEventDispatcher;

		public function AchieveManager( enforcer : SingletonEnforcer )
		{
			if ( !enforcer )
			{
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );
			}
			_props = new Dictionary();
		}

		public function addAchievement( achievements : AchievementObject ) : void
		{
			_achievements = achievements;

			//checkPropertyExists( a.children );
			//_achievements[ a.id ] = a;
		}

		public function addDispatcher( d : IEventDispatcher ) : void
		{
			dispatcher = d;
		}

		public function addProperty( p : AchieveProperty ) : void
		{
			_props[ p.name ] = p;
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

		public function checkAchievements( theTags : Array = null ) : Vector.<AchievementObject>
		{
			var result : Vector.<AchievementObject> = null;

			for ( var n : String in _achievements )
			{
				var achivement : AchievementObject = _achievements[ n ];

				if ( achivement.unlocked == false )
				{
					var aActiveProps : int = 0;

					for ( var p : int = 0; p < achivement.properties.length; p++ )
					{
						var aProp : AchieveProperty = _props[ achivement.properties[ p ]];

						if (( theTags == null || hasTag( aProp, theTags )) && aProp.isActive())
						{
							aActiveProps++;
						}
					}

					if ( aActiveProps == achivement.properties.length )
					{
						achivement.unlocked = true;

						result = result || new Vector.<AchievementObject>;
						result.push( achivement );
					}
				}
			}

			return result;
		}

		public function defineAchievement( theName : String, relatedProps : Array ) : void
		{
			checkPropertyExists( relatedProps );
			//_achievements[ theName ] = new Achievement( theName, relatedProps );
		}

		public function defineProperty( theName : String, theInitialValue : int, theaActivationMode : String, theValue : int, theTags : Array = null ) : void
		{
			//

			//_props[ theName ] = new AchieveProperty( theName, theInitialValue, theaActivationMode, theValue, theTags );
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

		public function getActiveAchievement( result : Vector.<AchievementObject> = null ) : Vector.<AchievementObject>
		{

			result ||= new Vector.<AchievementObject>();

			if ( _achievements )
			{

			}

			return result;
		}

		public function getValue( prop : String ) : int
		{
			checkPropertyExists( prop );
			return _props[ prop ].value;
		}

		public function initialize( url : String, missions : Array ) : void
		{
			if ( _initialized )
				return;

			_initialized = true;

			var file : File = new File( url );

		}

		public function processAchievement() : void
		{

		}

		public function resetProperties( theTags : Array = null ) : void
		{
			for ( var n : String in _props )
			{
				var aProp : AchieveProperty = _props[ n ];

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

		private function hasTag( theProp : AchieveProperty, theTags : Array ) : Boolean
		{
			var result : Boolean = false;

			for ( var i : int = 0; i < theTags.length; i++ )
			{
				/*if ( theProp.tags != null && theProp.tags.indexOf( theTags[ i ]) != -1 )
				{
					result = true;
					break;
				}*/
			}

			return result;
		}
	}
}

class SingletonEnforcer
{
}
