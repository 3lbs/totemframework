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

	import flash.events.Event;

	import totem.core.task.Task;

	public class WaitForLoadTask extends Task
	{
		private var dispatcher : ILoadTask;

		public function WaitForLoadTask( target : ILoadTask )
		{
			super();

			dispatcher = target;

			dispatcher.addEventListener( Event.COMPLETE, handleComplete );
		}

		override protected function doStart() : void
		{
			dispatcher.load();
		}

		protected function handleComplete( event : Event ) : void
		{
			// TODO Auto-generated method stub
			complete();
		}
	}
}
