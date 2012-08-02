package totem.monitors
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.casalib.events.RemovableEventDispatcher;

	public class CompleteRequireMonitor extends RemovableEventDispatcher implements IListID
	{
		private var _resources : Vector.<IRequireMonitor>;

		public function CompleteRequireMonitor( target : IEventDispatcher = null )
		{
			super( target );
		}

		public function addResource( resource : IRequireMonitor ) : void
		{
			_resources.push( resource );

			resource.addEventListener( Event.COMPLETE, resourceComplete );
		}

		public function start() : void
		{
			startResources();
		}

		private function startResources() : Boolean
		{
			var isBuilding : Boolean = false;

			for each ( var proxy : IStartMonitor in _resources )
			{
				if( proxy is IRequireMonitor )
				{
					if ( IRequireMonitor ( proxy ).canStart())
					{
						proxy.start();
						isBuilding = true;
					}
					
				}
				else if ( proxy.status == AbstractProxy.EMPTY )
				{
					proxy.start();
				}
			}

			return isBuilding;
		}
		
		private function resourceComplete( eve : Event ) : void
		{
			// we still have resources to start?
			if ( !startResources() && allResourceComplete())
			{
				dispatchEvent( new Event( Event.COMPLETE ));
			}
		}
		
		public	function getItemByID( value : * ) : *
		{
			for each ( var dispatcher : IStartMonitor in _resources )
			{
				if ( dispatcher.id == value )
					return dispatcher;
			}
			// serach the array for item with id = value;
			return null;
		}
			
		private function allResourceComplete() : Boolean
		{
			var complete : Boolean = true;

			for each ( var proxy : IStartMonitor in _resources )
			{
				if ( !proxy.isComplete())
				{
					complete = false;
				}
			}

			return complete;
		}

		override public function destroy() : void
		{
			if ( !destroyed )
			{
				super.destroy();

				_resources.length = 0;
				_resources = null;
			}
		}
	}
}

