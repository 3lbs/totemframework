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

package totem3d.loaders
{

	import flare.loaders.Flare3DLoader;

	import flash.events.Event;

	import totem.monitors.AbstractMonitorProxy;

	public class Flare3DMonitor extends AbstractMonitorProxy
	{

		public var data : *;

		private var _loader : Flare3DLoader;

		public function Flare3DMonitor( d : *, id : String = "" )
		{
			super( id );

			data = d;
			loader = new Flare3DLoader( data );
		}

		override public function destroy() : void
		{
			super.destroy();

			_loader.dispose();
			_loader = null;

			data = null;
		}

		public function get loader() : Flare3DLoader
		{
			return _loader;
		}

		public function set loader( value : Flare3DLoader ) : void
		{
			_loader = value;
		}

		override public function start() : void
		{
			super.start()

			_loader.addEventListener( Event.COMPLETE, handleComplete );
			_loader.load();

		}

		private function handleComplete( eve : Event ) : void
		{
			finished();
		}
	}
}
