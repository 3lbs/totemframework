package totem.monitors
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.casalib.events.RemovableEventDispatcher;

	public class AbstractProxy extends RemovableEventDispatcher implements IStartMonitor
	{

		public static const EMPTY : int = 0;

		public static const LOADING : int = 1;

		public static const COMPLETE : int = 2;

		public static const FAILED : int = 3;

		private var _status : int = EMPTY;

		private var _id : String;

		public function AbstractProxy( target : IEventDispatcher = null )
		{
			super( target );
		}

		public function isComplete() : Boolean
		{
			return status == COMPLETE;
		}
		
		public function get status () : Number
		{
			return _status;
		}
		
		public function start() : void
		{
			_status = LOADING;
		}

		protected function finished() : void
		{
			_status = COMPLETE;
			dispatchEvent( new Event( Event.COMPLETE ));
		}

		protected function failed() : void
		{
			_status = FAILED;
			dispatchEvent( new Event( Event.COMPLETE ));
		}

		public function get isFailed() : Boolean
		{
			return status == FAILED;
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

