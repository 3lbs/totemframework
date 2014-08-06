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

package totem.core.task.util
{

	import totem.events.IRemovableEventDispatcher;

	public interface ILoadTask extends IRemovableEventDispatcher
	{
		function isComplete() : Boolean;

		function load() : void;

		function get status() : Number;

		function unloadData() : void;
	}
}
