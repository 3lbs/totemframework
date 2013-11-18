
package totem.components.commands
{

	import flash.events.IEventDispatcher;
	
	import totem.totem_internal;
	import totem.core.TotemComponent;
	import totem.core.TotemEntity;
	import totem.core.mvc.controller.api.ICommandMap;
	import totem.core.mvc.controller.api.SignalCommandMap;
	import totem.core.mvc.controller.command.Command;
	import totem.core.mvc.controller.command.SerialCommand;
	import totem.monitors.promise.Deferred;
	import totem.monitors.promise.IPromise;

	use namespace totem_internal;

	public class CommandComponent extends TotemComponent
	{
		public var eventDispatcher : IEventDispatcher;

		private var _commandMap : ICommandMap;

		private var deconstructCommand : SerialCommand;

		private var monitor:Deferred;

		public function CommandComponent( name : String = null )
		{
			super( name );
		}

		public function get commandMap():ICommandMap
		{
			return _commandMap;
		} 

		override protected function onAdd() : void
		{
			super.onAdd();

			_commandMap = new SignalCommandMap( getInjector());
			
			injector.map( ICommandMap ).toValue( commandMap );

			owner.onAddSignal.addOnce( doInitialize );
		}
		
		private function doInitialize( entity : TotemEntity ):void
		{
		}
		
		override protected function onRemove() : void
		{
			super.onRemove();
			destroy();
		}

		override public function deconstruct() : IPromise
		{
			if ( deconstructCommand )
			{
				deconstructCommand.onComplete.addOnce( deconstructComplete );
				excuteCommand( deconstructCommand );
				return null;
			}

			return null;
		}

		private function deconstructComplete( command : Command ) : void
		{
			deconstructCommand = null;
			
			monitor.resolve( this );
			monitor = null;
		}

		public function excuteCommand( command : * ) : void
		{
			commandMap.executeCommand( command );
		}

		public function addDeconstructCommand( command : Command ) : void
		{
			deconstructCommand ||= new SerialCommand();
			deconstructCommand.append( command );
		}

		override public function destroy() : void
		{
			super.destroy();
			commandMap.destroy();
		}
	}
}
