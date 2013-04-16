package totem.monitors.startupmonitor
{
	import flash.events.Event;
	
	import totem.events.RemovableEventDispatcher;
	
	public class StartupResourceProxy extends RemovableEventDispatcher implements IStartupProxy
	{
		protected var _dependency:Array;
		
		public static const EMPTY :int = 1;
		public static const LOADING :int = 2;
		public static const TIMED_OUT :int = 3;
		public static const FAILED :int = 4;
		public static const LOADED :int = 5;
		 
		protected var status :int;
		
		protected var _appResourceProxy:IStartupProxy;
		
		public function StartupResourceProxy( appResourceProxy:IStartupProxy )
		{
			_appResourceProxy = appResourceProxy;
			status = EMPTY;
			_dependency = new Array();
			
		}
		
		public function set requires( resources :Array ) :void 
		{
			_dependency = resources;
		}
		
		public function addDependency ( resource : StartupResourceProxy ) : void
		{
			if ( status != EMPTY )
				return;
			
			_dependency.push( resource );
		}
		
		public function get dependency() :Array {
			return _dependency;
		}
		
		public function isOkToLoad () : Boolean
		{
			if ( status != EMPTY )
				return false;
				
			for each ( var r:StartupResourceProxy in _dependency )
			{
				if ( ! r.isLoaded() )
					return false;
			}
			return true;	
		}
		
		public function isLoaded() : Boolean
		{
			return status == LOADED;
		}
		
		public function load () : void
		{
			status = LOADING;
			_appResourceProxy.addEventListener( Event.COMPLETE, complete, false, 0, true );
			_appResourceProxy.load();	
		}
		
		protected function complete( eve:Event = null ) : void
		{
			_dependency.length = 0;
			
			_appResourceProxy.removeEventListener( Event.COMPLETE, complete );
			status = LOADED;
			
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			_appResourceProxy.destroy();
		}
	}
}