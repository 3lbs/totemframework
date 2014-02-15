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

	import totem.core.TotemComponent;

	public class SoundComponent extends TotemComponent
	{

		public static const NAME : String = "SoundComponent";

		public function SoundComponent( name : String = null )
		{
			super( name || NAME );
		}
	}
}
