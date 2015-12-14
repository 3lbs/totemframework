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

	import totem.components.display.IDisplay2DRenderer;

	public interface IAnimator extends IDisplay2DRenderer
	{

		function goToAndPlay( animName : String, frame : int, loop : int = 1 ) : void;

		function pauseAnimation() : void;

		function playAnimation( animName : String, loop : int = 1 ) : void;

		function stopAnimation() : void;
	}
}
