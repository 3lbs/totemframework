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

package application.task
{

	import totem.core.task.Task;

	public class FunctionTask extends Task
	{
		private var _function : Function;

		public function FunctionTask( func : Function )
		{
			_function = func;
			super();
		}

		override protected function doStart() : void
		{
			_function.call( null );
			complete();
		}
	}
}
