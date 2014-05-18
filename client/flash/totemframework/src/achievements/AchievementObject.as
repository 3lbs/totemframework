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

	public class AchievementObject
	{

		public var body : String;

		public var nodes : Vector.<String>;

		public var properties : Vector.<AchieveProperty> = new Vector.<AchieveProperty>();

		public var required : Vector.<String>;

		public var rewards : Vector.<AchievementReward>;

		protected var _id : String;

		private var _state : int;

		private var _unlocked : Boolean;

		private var children : Vector.<AchievementObject>;

		// id : String, relatedProps : Array 
		public function AchievementObject()
		{
			/*_name = id;
			_props = relatedProps;*/

			children = new Vector.<AchievementObject>();

			_unlocked = false;
		}

		public function addChild( a : AchievementObject ) : void
		{
			children.push( a );
		}

		public function getChildByID() : AchievementObject
		{
			return null;
		}

		public function getChildren() : Vector.<AchievementObject>
		{
			return children;
		}

		public function get id() : String
		{
			return _id;
		}

		public function set id( value : String ) : void
		{
			_id = value;
		}

		public function onActivate() : void
		{

		}

		public function toString() : String
		{
			return "[Achivement " + id + "]";
		}

		[Transient]
		public function get unlocked() : Boolean
		{
			return _unlocked;
		}

		public function set unlocked( v : Boolean ) : void
		{
			_unlocked = v;
		}
	}
}
