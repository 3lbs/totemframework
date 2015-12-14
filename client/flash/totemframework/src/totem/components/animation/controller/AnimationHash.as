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

package totem.components.animation.controller
{

	import totem.utils.Rndm;

	public class AnimationHash
	{

		public var list : Vector.<AnimationAction>;

		public var name : String;

		public function AnimationHash()
		{
		}

		public function getRandomAnimation( key : String ) : AnimationAction
		{
			return list[ Rndm.integer( 0, list.length )];
		}
	}
}
