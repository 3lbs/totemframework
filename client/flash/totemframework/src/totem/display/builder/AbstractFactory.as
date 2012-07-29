package totem.display.builder
{
	import flash.events.IEventDispatcher;
	
	import org.casalib.events.RemovableEventDispatcher;
	
	import totem.monitors.IStartMonitor;
	
	public class AbstractFactory extends RemovableEventDispatcher implements IStartMonitor
	{
		protected var failed : Boolean;
		
		protected var _id : *;
		
		public function AbstractFactory( id : * )
		{
			_id = id;
		}
		
		public function start() : void
		{
			
		}
		
		public function get isFailed() : Boolean
		{
			return failed;
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