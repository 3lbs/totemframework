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

package totem.sound
{

	public class SoundParam
	{

		public var group : String = "SFX";

		public var loops : int;

		public var mute : Boolean;

		public var panning : Number = 0;

		public var permanent : Boolean;

		public var sound : Object;

		public var soundID : String;

		public var volume : Number = 1;

		public function SoundParam()
		{
		}
	}
}
