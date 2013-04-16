package totem.monitors
{

	import flash.events.Event;

	public class CompleteMonitor extends AbstractMonitorProxy implements IListID
	{
		
		public var data : Object;
		
		protected var _resources : Vector.<IStartMonitor>;

		private var _failedCount : int;

		public function CompleteMonitor( id : String = "" )
		{
			super( id );

			_resources = new Vector.<IStartMonitor>();
		}

		/**
		 *
		 * @param ev
		 * @param eventType
		 */
		public function addDispatcher( monitor : IStartMonitor, eventType : String = Event.COMPLETE ) : IStartMonitor
		{
			if ( !monitor )
				return null;

			monitor.addEventListener( eventType, onComplete );
			_resources.push( monitor );
			
			return monitor;
		}

		override public function start() : void
		{
			super.start();

			_failedCount = 0;
			
			if ( !doStartResource() && allResourceComplete() )
			{
				finished();
			}
		}

		private function doStartResource() : Boolean
		{
			var isBuilding : Boolean = false;

			if ( _resources.length == 0 || allResourceComplete() )
			{
				return isBuilding;
			}

			// sequnce loading with time delayed?
			// 
			for each ( var proxy : IStartMonitor in _resources )
			{
				if ( proxy is IRequireMonitor )
				{
					if ( IRequireMonitor( proxy ).canStart())
					{
						proxy.start();
						isBuilding = true;
					}

				}
				else if ( proxy.status == AbstractMonitorProxy.EMPTY )
				{
					proxy.start();
					isBuilding = true;
				}
			}

			return isBuilding;
		}

		private function onComplete( eve : Event ) : void
		{
			var target : IStartMonitor = eve.target as IStartMonitor;
			target.removeEventListener( eve.type, onComplete );

			if ( target.isFailed )
			{
				_failedCount += 1;
			}

			if ( !doStartResource() && allResourceComplete())
			{
				finished();
			}
		}

		private function allResourceComplete() : Boolean
		{
			var isComplete : Boolean = true;

			for each ( var proxy : IStartMonitor in _resources )
			{
				if ( !proxy.isComplete())
				{
					isComplete = false;
				}
			}

			return isComplete;
		}

		public function get list() : Vector.<IStartMonitor>
		{
			return _resources;
		}

		override public function get isFailed() : Boolean
		{
			return _failedCount > 0;
		}

		/**
		 *
		 * @return
		 */
		public function get totalDispatchers() : int
		{
			return _resources.length;
		}

		public function getItemByID( value : * ) : *
		{

			for each ( var dispatcher : IStartMonitor in _resources )
			{
				if ( dispatcher.id == value )
					return dispatcher;
			}
			// serach the array for item with id = value;
			return null;
		}

		override public function destroy() : void
		{
			super.destroy();
			
			data = null;
			
			while ( _resources.length )
				_resources.pop().destroy();

			_resources = null;
		}

	}
}

