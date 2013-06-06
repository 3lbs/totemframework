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

	import flash.events.Event;

	public class ProgressMonitor extends EventMonitor implements IProgressMonitor
	{
		public function ProgressMonitor()
		{
			super();
		}

		public function get precentComplete() : int
		{
			return ( _monitors.size / count ) * 100;
		}

		override protected function onComplete( eve : Event ) : void
		{
			super.onComplete( eve );

		}
	}
}
