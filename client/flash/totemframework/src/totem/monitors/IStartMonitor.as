package totem.monitors
{
	import totem.totem_internal;
	import totem.core.IDestroyable;
	import totem.events.IRemovableEventDispatcher;
	
	public interface IStartMonitor extends IRemovableEventDispatcher, IDestroyable
	{
		
		function isComplete() : Boolean;
		
		function get status () : Number;

		function start () : void;
		
		function get isFailed () : Boolean;
		
		function get id () : *;
	}
}

