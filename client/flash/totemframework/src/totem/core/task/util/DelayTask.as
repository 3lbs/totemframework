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

	import totem.core.task.Task;
	import totem.monitors.promise.wait;

	public class DelayTask extends Task
	{
		private var time : Number;

		public function DelayTask( t : Number, isRestartable : Boolean = true )
		{
			time = t;
			super();

			setRestartable( isRestartable );

		}

		override protected function doStart() : void
		{
			wait( time, complete );
		}
	}
}
