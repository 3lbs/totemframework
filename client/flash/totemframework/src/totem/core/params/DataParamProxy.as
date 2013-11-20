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

package totem.core.params
{

	import flash.events.Event;

	import org.osflash.vanilla.extract;

	import totem.events.RemovableEventDispatcher;
	import totem.loaders.promise.JSONPromise;
	import totem.monitors.promise.IPromise;
	import totem.monitors.startupmonitor.IStartupProxy;

	public class DataParamProxy extends RemovableEventDispatcher implements IStartupProxy
	{
		private var _class : Class;

		private var _data : *;

		private var _filename : String;

		public function DataParamProxy( filename : String, clazz : Class )
		{
			_class = clazz;
			_filename = filename;
		}

		public function get clazz() : Class
		{
			return _class;
		}

		public function get data() : *
		{
			return _data;
		}

		override public function destroy() : void
		{
			super.destroy();
			_class = null;
			_data = null;
		}

		public function load() : void
		{
			var promise : IPromise = JSONPromise.create( _filename ).completes( handleComplete ).fails( handleFail );
		}

		private function handleComplete( object : Object ) : void
		{
			_data = extract( object, _class );
			dispatchEvent( new Event( Event.COMPLETE ));
		}

		private function handleFail( error : Error ) : void
		{
			dispatchEvent( new Event( Event.COMPLETE ));
		}
	}
}
