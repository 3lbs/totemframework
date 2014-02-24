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

package totem.core.time.scheduler
{

	import totem.core.IDestroyable;

	public interface ISchedule extends IDestroyable
	{

		function completeCallback() : void;

		function get duration() : Number;

		function getElaspedTime() : Number;

		function get startTime() : Number;
	}
}
