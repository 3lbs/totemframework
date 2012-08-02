package totem.monitors
{
	import org.casalib.events.IRemovableEventDispatcher;
	
	public interface IStartMonitor extends IRemovableEventDispatcher
	{
		
		function isComplete() : Boolean;
		
		function get status () : Number;

		function start () : void;
		
		function get isFailed () : Boolean;
		
		function get id () : *;
	}
}

