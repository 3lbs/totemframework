package totem.monitors
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import org.casalib.events.RemovableEventDispatcher;

	public class CompleteProxy extends RemovableEventDispatcher implements IRequireMonitor
	{

		public static const EMPTY : int = 0;

		public static const LOADING : int = 1;

		public static const COMPLETE : int = 2;

		public static const FAILED : int = 3;

		private var status : int = EMPTY;

		private var _requires : Vector.<IRequireMonitor>;

		private var _id : String;

		public function CompleteProxy( target : IEventDispatcher = null )
		{
			super( target );
			_requires = new Vector.<IRequireMonitor>();
		}

		public function isComplete() : Boolean
		{
			return status == COMPLETE;
		}

		public function start() : void
		{
			status = LOADING;
		}

		protected function finished() : void
		{
			status = COMPLETE;
			dispatchEvent( new Event( Event.COMPLETE ));
		}

		protected function failed() : void
		{
			status = FAILED;
			dispatchEvent( new Event( Event.COMPLETE ));
		}

		public function requires( ... args ) : void
		{
			for each ( var obj : IRequireMonitor in args )
			{
				_requires.push( obj );
			}
		}

		public function canStart() : Boolean
		{
			// you dont want to start a loading or complete proxy again
			if ( status != EMPTY )
			{
				return false;
			}

			// test all the dependent proxy are ready
			for each ( var proxy : IRequireMonitor in _requires )
			{
				if ( proxy.isComplete() == false )
				{
					return false;
				}
			}

			return true;
		}

		public function get isFailed() : Boolean
		{
			return status == FAILED;
		}

		override public function destroy() : void
		{
			super.destroy();

			_requires.length = 0;
			_requires = null;
		}

		public function get id() : *
		{
			return _id;
		}

		public function set id( value : * ) : void
		{
			_id = value;
		}

	}
}

