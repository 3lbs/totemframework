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

	import flash.utils.Dictionary;

	public class AchieveManager
	{

		public static const ACTIVE_IF_EQUAL_TO : String = "==";

		public static const ACTIVE_IF_GREATER_THAN : String = ">";

		public static const ACTIVE_IF_LESS_THAN : String = "<";

		public static const ACTIVE_IF_NOT_EQUAL_TO : String = "!=";

		private static var _instance : AchieveManager;

		public static function getInstance() : AchieveManager
		{
			return _instance ||= new AchieveManager( new SingletonEnforcer());
		}

		private var _indexAchievements : Achievement;


		private var _props : Dictionary;

		private var tempResult : Vector.<Achievement> = new Vector.<Achievement>();

		public function AchieveManager( enforcer : SingletonEnforcer )
		{
			if ( !enforcer )
			{
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );
			}
			_props = new Dictionary( true );
		}

		public function addProperty( p : AchieveProperty, enum : Object ) : void
		{
			_props[ p ] = enum;
		}

		public function addValue( theProp : Object, theValue : int ) : void
		{

			for ( var key : AchieveProperty in _props )
			{
				if ( _props[ key ] == theProp )
				{
					key.value = int( key.value ) + theValue;
				}
			}

		}

		///  this is for the button to flash prompt users a achievement has completed
		//  this could also be a an update loop.   
		//  but check and update state on app changes
		public function checkAchievements() : Boolean
		{
			var achivements : Vector.<Achievement> = _indexAchievements.getActiveAchievements( tempResult );
			var achivement : Achievement;
			var i : int = achivements.length;

			var success : Boolean = false;

			while ( i-- )
			{
				achivement = achivements[ i ];

				//  you might want to make a list of ones you already alerted about
				if ( achivement.checkPropertiesComplete())
				{
					success = true;
					
					achivement.update();
				}
			}

			tempResult.length = 0;

			return success;
		}

		public function getAchievementByID( id : String ) : Achievement
		{
			return _indexAchievements.getAchievementByID( id );
		}

		public function getActiveAchievements( result : Vector.<Achievement> = null, tags : Array = null ) : Vector.<Achievement>
		{

			result ||= new Vector.<Achievement>();
			result.concat( _indexAchievements.getActiveAchievements( result ));
			return result;
		}

		public function getViewableAchievements( result : Vector.<Achievement> = null, tags : Array = null ) : Vector.<Achievement>
		{

			result ||= new Vector.<Achievement>();
			result.concat( _indexAchievements.getViewableAchievements( result ));
			return result;
		}

		public function initialize( achievements : Achievement ) : void
		{
			_indexAchievements = achievements;
			_indexAchievements.update();
			
		}

		public function removeProperty( p : AchieveProperty ) : void
		{
			if ( _props[ p ])
			{
				_props[ p ] = null;
				delete _props[ p ];

			}
		}

		private function checkPropertyExists( prop : * ) : Boolean
		{

			if ( prop is String )
			{
				return ( _props[ prop ] != null )

			}
			else if ( prop is Array )
			{
				for ( var i : int = 0; i < prop.length; i++ )
				{
					if ( _props[ prop[ i ]] == null )
					{
						return false;
					}
				}
			}

			return false;
		}
	}
}

class SingletonEnforcer
{
}
