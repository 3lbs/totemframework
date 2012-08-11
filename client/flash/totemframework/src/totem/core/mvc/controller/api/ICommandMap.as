package totem.core.mvc.controller.api
{
	import totem.core.IDestroyable;
	import totem.core.mvc.controller.command.Command;

	public interface ICommandMap extends IDestroyable
	{
		function executeCommand( commandClassOrObject : * ) : void;
	}
}
