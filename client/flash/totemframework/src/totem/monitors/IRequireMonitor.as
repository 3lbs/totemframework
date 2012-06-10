package totem.monitors
{
	import org.casalib.events.IRemovableEventDispatcher;
	
	public interface IRequireMonitor extends IStartMonitor
	{
		function isComplete() : Boolean;
		
		function requires ( ... args ) : void;
		
		function canStart () : Boolean;
	
	}
}

