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

package totem.core
{

	public class TotemDestroyable extends Destroyable
	{

		protected var initilized : Boolean;

		private var _name : String;

		public function TotemDestroyable( name : String )
		{
			_name = name;
		}

		public function initialize() : void
		{
			initilized = true;
		}

		public function getName() : String
		{
			return _name;
		}
	}
}
