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

package totem.monitors.progress
{

	import totem.monitors.simple.EventMonitor;

	public class ProgressMonitor extends EventMonitor implements IProgressMonitor
	{
		public function ProgressMonitor()
		{
			super();
		}

		public function isComplete() : Boolean
		{
			return _monitors.size == 0 || precentComplete == 100;
		}

		public function get precentComplete() : int
		{
			return ( _monitors.size / completeCount ) * 100;
		}

		public function reset() : void
		{
			_monitors.clear();
			completeCount = 0;
		}
	}
}
