package totem.monitors
{
	import flash.events.Event;
	
	import ladydebug.Logger;
	
	import totem.totem_internal;
	import totem.events.RemovableEventDispatcher;

	public class AbstractMonitorProxy extends RemovableEventDispatcher implements IStartMonitor
	{
		public static const EMPTY : int = 0;
		
		public static const LOADING : int = 1;
		
		public static const COMPLETE : int = 2;
		
		public static const FAILED : int = 3;

		private var _status : int = EMPTY;

		private var _id : String;

		public function AbstractMonitorProxy( id : String = "" )
		{
			_id = id;
		}

		public function isComplete() : Boolean
		{
			return status == COMPLETE;
		}
		
		totem_internal function start () : void
		{
			_status = LOADING;
			start();			
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
			if ( _status == COMPLETE )
				return;
			
			complete();
		}

		public function complete  () : void
		{
			_status = COMPLETE;
			dispatchEvent( new Event( Event.COMPLETE ));			
		}
		
		protected function failed() : void
		{
			
			Logger.error( this, "Complete Monitor Failed", "AbstartMonitorProxy" );
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

