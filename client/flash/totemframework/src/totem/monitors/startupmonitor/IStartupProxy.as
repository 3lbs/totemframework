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

package totem.monitors.startupmonitor
{

	import totem.events.IRemovableEventDispatcher;

	public interface IStartupProxy extends IRemovableEventDispatcher
	{

		function destroy() : void;
		function load() : void;
	}
}
