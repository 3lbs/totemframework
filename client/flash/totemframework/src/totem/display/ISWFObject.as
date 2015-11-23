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

package totem.display
{

	import totem.core.IDestroyable;
	import totem.events.IRemovableEventDispatcher;

	public interface ISWFObject extends IDestroyable, IRemovableEventDispatcher
	{
		function set display( value : Boolean ) : void;

		function loadURL( value : String ) : void;

		function unload() : void;
		
	}
}
