package totem.monitors
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import org.casalib.events.RemovableEventDispatcher;

	public class CompleteRequireMonitor extends RemovableEventDispatcher
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

			for each ( var proxy : IRequireMonitor in _resources )
			{
				if ( proxy.canStart())
				{
					proxy.start();
					isBuilding = true;
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

		private function allResourceComplete() : Boolean
		{
			var complete : Boolean = true;

			for each ( var proxy : IRequireMonitor in _resources )
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

