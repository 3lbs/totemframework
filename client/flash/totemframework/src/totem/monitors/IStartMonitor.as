package totem.monitors
{
	import org.casalib.events.IRemovableEventDispatcher;
	
	public interface IStartMonitor extends IRemovableEventDispatcher
	{
		function start () : void;
		
		function get isFailed () : Boolean;
		
		function get id () : *;
	}
}

