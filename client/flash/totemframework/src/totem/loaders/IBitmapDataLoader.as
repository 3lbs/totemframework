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

package totem.loaders
{

	import flash.display.BitmapData;
	
	import totem.events.IRemovableEventDispatcher;

	public interface IBitmapDataLoader extends IRemovableEventDispatcher
	{
		function get bitmapData() : BitmapData;

		function destroy() : void
	}
}
