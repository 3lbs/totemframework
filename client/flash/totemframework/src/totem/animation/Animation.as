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

package totem.animation
{

	public class Animation
	{

		public var loop : int;

		public var name : String;

		public function Animation( name : String = "", loop : int = 1 )
		{
			this.name = name;
			this.loop = loop;
		}
	}
}
