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

	import flash.events.Event;

	public class StartupFactoryProxy extends StartupResourceProxy
	{
		public function StartupFactoryProxy()
		{
			super( null );
		}

		override public function load() : void
		{
			status = LOADING;
		}

		override protected function complete( eve : Event = null ) : void
		{
			_dependency.length = 0;

			status = LOADED;

			dispatchEvent( new Event( Event.COMPLETE ))
		}
	}
}
