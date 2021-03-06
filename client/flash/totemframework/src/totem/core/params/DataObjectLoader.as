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

package totem.core.params
{

	import flash.events.Event;
	import flash.utils.Dictionary;

	import org.as3commons.collections.LinkedList;

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

		public function getData( clazz : Class, name : String = "" ) : *
		{
			return dataParamMap[ clazz || name ];
		}

		public function setData( data : Object, clazz : Class = null, name : String = "" ) : void
		{
			var id : * = clazz || name;

			if ( dataParamMap[ id ])
			{
				return;
			}

			dataParamMap[ id ];
		}

		override public function start() : void
		{
			if ( !_monitors )
				_monitors = new LinkedList();

			super.start();

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
