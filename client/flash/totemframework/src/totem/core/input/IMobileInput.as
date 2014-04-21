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

package totem.core.input
{

	public interface IMobileInput
	{

		function handlePan( globalX : Number, globalY : Number, end : Boolean = false ) : void;

		function handleSingleTouch( x : Number, y : Number ) : void;

		function handleTouchZoom( scale : Number, offsetX : Number, offsetY : Number, end : Boolean = false ) : void;
	}
}
