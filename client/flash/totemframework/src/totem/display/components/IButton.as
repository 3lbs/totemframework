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

package totem.display.components
{

	import totem.events.IRemovableEventDispatcher;

	public interface IButton extends IRemovableEventDispatcher
	{

		function get data() : Object;

		function set data( value : Object ) : void;

		function destroy() : void;

		function get name() : String;

		function get selected() : Boolean;

		function set selected( value : Boolean ) : void;
	}
}
