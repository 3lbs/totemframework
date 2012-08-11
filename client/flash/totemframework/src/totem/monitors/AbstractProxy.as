package totem.monitors
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.casalib.events.RemovableEventDispatcher;

	public class AbstractProxy extends RemovableEventDispatcher implements IStartMonitor
	{

		private var _status : int = LoaderConst.EMPTY;

		private var _id : String;

		public function AbstractProxy( target : IEventDispatcher = null )
		{
			super( target );
		}

		public function isComplete() : Boolean
		{
			return status == LoaderConst.COMPLETE;
		}
		
		public function get status () : Number
		{
			return _status;
		}
		
		public function start() : void
		{
			_status = LoaderConst.LOADING;
		}

		protected function finished() : void
		{
			_status = LoaderConst.COMPLETE;
			dispatchEvent( new Event( Event.COMPLETE ));
		}

		protected function failed() : void
		{
			_status = LoaderConst.FAILED;
			dispatchEvent( new Event( Event.COMPLETE ));
		}

		public function get isFailed() : Boolean
		{
			return status == LoaderConst.FAILED;
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

