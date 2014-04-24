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

	public class Achievement
	{
		private var _name : String;

		private var _props : Array;

		private var _unlocked : Boolean;
		
		
		private var _state : int;

		public function Achievement( id : String, relatedProps : Array )
		{
			_name = id;
			_props = relatedProps;
			_unlocked = false;
		}

		public function get name() : String
		{
			return _name;
		}

		public function get props() : Array
		{
			return _props;
		}

		public function toString() : String
		{
			return "[Achivement " + _name + "]";
		}

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
