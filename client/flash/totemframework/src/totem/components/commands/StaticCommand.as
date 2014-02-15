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

package totem.components.commands
{

	import totem.core.Destroyable;

	public class StaticCommand extends Destroyable
	{
		private var _busy : Boolean;

		public function StaticCommand()
		{
			super();
		}

		public function complete() : void
		{
			_busy = false;
		}

		public function execute() : void
		{
			_busy = true;
		}

		public function intialize() : void
		{

		}

		public function isBusy() : Boolean
		{
			return _busy;
		}
	}
}
