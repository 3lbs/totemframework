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
	import flash.utils.Dictionary;
	
	import totem.monitors.StartupDispatcherMonitor;

	public class DataObjectLoader extends StartupDispatcherMonitor
	{

		private static var _instance : DataObjectLoader;

		public static function getInstance() : DataObjectLoader
		{
			return _instance ||= new DataObjectLoader( new SingletonEnforcer());
		}

		private var dataParamMap : Dictionary = new Dictionary();

		public function DataObjectLoader( singletonEnforcer : SingletonEnforcer )
		{
			if ( !singletonEnforcer )
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );
		}

		public function createDataLoader( filenName : String, clazz : Class ) : DataParamProxy
		{
			if ( dataParamMap[ clazz ])
				return null;

			return addProxy( new DataParamProxy( filenName, clazz )) as DataParamProxy;
		}

		override public function destroy() : void
		{
			removeEventListeners();

			unloadData();

			_monitors.clear();
			_monitors = null;
		}

		public function getData( clazz : Class ) : *
		{
			return dataParamMap[ clazz ];
		}

		override protected function onComplete( eve : Event ) : void
		{
			var dispatcher : DataParamProxy = eve.target as DataParamProxy;

			dataParamMap[ dispatcher.clazz ] = dispatcher.data;
			super.onComplete( eve );


			dispatcher.destroy();
		}
	}
}

class SingletonEnforcer
{
}
