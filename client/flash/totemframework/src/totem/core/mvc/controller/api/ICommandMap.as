package totem.core.mvc.controller.api
{
	import totem.core.IDestroyable;

	public interface ICommandMap extends IDestroyable
	{
		function mapCommand ( type : *, commandClass : Class, runOnce : Boolean = false ) : CommandMapping
		
		function executeCommand( command : * ) : void
	}
}
