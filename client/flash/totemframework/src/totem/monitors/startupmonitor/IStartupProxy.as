package  totem.monitors.startupmonitor
{
	import totem.events.IRemovableEventDispatcher;
	
	public interface IStartupProxy extends IRemovableEventDispatcher
	{
		function load () : void;
		
		function destroy () : void;
	}
}