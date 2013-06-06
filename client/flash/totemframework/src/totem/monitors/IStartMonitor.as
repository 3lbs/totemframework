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

package totem.monitors
{

	import totem.core.IDestroyable;
	import totem.events.IRemovableEventDispatcher;

	public interface IStartMonitor extends IRemovableEventDispatcher, IDestroyable
	{

		function get id() : *;

		function isComplete() : Boolean;

		function get isFailed() : Boolean;

		function start() : void;

		function get status() : Number;
	}
}

