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

package totem.components.animation
{

	import totem.observer.NotifBroadcaster;

	public interface IAnimator
	{

		function get broadcaster() : NotifBroadcaster;

		function pauseAnimation() : void;

		function playAnimation( animName : String, type : AnimatorEnum = null ) : void;

		function stopAnimation() : void;
	}
}
