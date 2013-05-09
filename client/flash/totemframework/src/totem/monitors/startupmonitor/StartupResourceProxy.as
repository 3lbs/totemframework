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

	import totem.events.RemovableEventDispatcher;

	public class StartupResourceProxy extends RemovableEventDispatcher implements IStartupProxy
	{

		public static const EMPTY : int = 1;

		public static const FAILED : int = 4;

		public static const LOADED : int = 5;

		public static const LOADING : int = 2;

		public static const TIMED_OUT : int = 3;

		protected var _appResourceProxy : IStartupProxy;

		protected var _dependency : Array;

		protected var status : int;

		public function StartupResourceProxy( appResourceProxy : IStartupProxy )
		{
			_appResourceProxy = appResourceProxy;
			status = EMPTY;
			_dependency = new Array();

		}

		public function addDependency( resource : StartupResourceProxy ) : void
		{
			if ( status != EMPTY )
				return;

			_dependency.push( resource );
		}

		public function get dependency() : Array
		{
			return _dependency;
		}

		override public function destroy() : void
		{
			super.destroy();

			_dependency.length = 0;
			_dependency = null;
			_appResourceProxy.destroy();
		}

		public function isLoaded() : Boolean
		{
			return status == LOADED;
		}

		public function isOkToLoad() : Boolean
		{
			if ( status != EMPTY )
				return false;

			for each ( var r : StartupResourceProxy in _dependency )
			{
				if ( !r.isLoaded())
					return false;
			}
			return true;
		}

		public function load() : void
		{
			status = LOADING;
			_appResourceProxy.addEventListener( Event.COMPLETE, complete, false, 0, true );
			_appResourceProxy.load();
		}

		public function set requires( resources : Array ) : void
		{
			_dependency = resources;
		}

		protected function complete( eve : Event = null ) : void
		{
			_dependency.length = 0;

			_appResourceProxy.removeEventListener( Event.COMPLETE, complete );
			status = LOADED;

			dispatchEvent( new Event( Event.COMPLETE ));
		}
	}
}
