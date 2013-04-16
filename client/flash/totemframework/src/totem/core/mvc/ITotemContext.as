package totem.core.mvc
{
	import flash.events.IEventDispatcher;
	
	import totem.core.ITotemSystem;
	import totem.core.TotemEntity;
	import totem.core.TotemGroup;
	
	public interface ITotemContext extends ITotemSystem
	{
		function createEntity( name : String = null ) : TotemEntity;
		
		function addGroup ( group : TotemGroup ) : void;
		
		function destroyEntity( name : String ) : void;
		
		function get eventDispatcher () : IEventDispatcher;
		
	}
}