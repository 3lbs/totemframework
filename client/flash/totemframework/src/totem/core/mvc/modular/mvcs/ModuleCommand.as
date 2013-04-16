package totem.core.mvc.modular.mvcs
{

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import totem.core.mvc.controller.command.Command;
	import totem.core.mvc.modular.core.IModuleEventDispatcher;

	public class ModuleCommand extends Command
	{

		[Inject]
		public var contextEventDispatcher : IEventDispatcher;

		[Inject]
		public var moduleEventDispatcher : IModuleEventDispatcher;

		protected function dispatchToModules( event : Event ) : Boolean
		{
			if ( moduleEventDispatcher.hasEventListener( event.type ))
				return moduleEventDispatcher.dispatchEvent( event );
			return true;
		}

		protected function dispatchContext( event : Event ) : Boolean
		{
			if ( contextEventDispatcher.hasEventListener( event.type ))
				return contextEventDispatcher.dispatchEvent( event );
			return true;
		}
	}
}
