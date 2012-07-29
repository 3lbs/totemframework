
package totem.core.command
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import totem.core.TotemComponent;
	import totem.totem_internal;

	use namespace totem_internal;

	public class CommandManagerComponent extends TotemComponent
	{
		public var eventDispatcher : IEventDispatcher;

		private var commandMap : CommandMap = new CommandMap();

		private var initializeCommand : CompositeCommand;

		private var singletonCommandMap : Dictionary;
		
		public function CommandManagerComponent( name : String = null )
		{
			super( name );
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			if ( initializeCommand )
			{
				executeCommandWithInjection( initializeCommand );
				initializeCommand.onComplete.addOnce( handleInitCommandComplete );
			}
			
		}
	
		override protected function onRemove() : void
		{
			super.onRemove();
			destroy();
		}
		
		public function registerSingletonCommand( command : Command, event : String, once : Boolean = false ) : void
		{
			singletonCommandMap ||= new Dictionary();
			singletonCommandMap[ command ] = event;
		}

		public function removeSingletonCommand( command : Command ) : void
		{

		}
		
		public function executeSingletonCommand ( event : String ) : void
		{
			var command : Command;
			
			
			excuteCommand( command );
		}
		
		
		public function executeCommandWithInjection( commandClassOrObject : * ) : void
		{
			var command : Command = commandClassOrObject;

			if ( commandClassOrObject is Class )
			{
				getInjector().map( commandClassOrObject );
				command = getInjector().getInstance( commandClassOrObject );
				getInjector().unmap( commandClassOrObject );
			}
			
			getInjector().injectInto( command );
			command.injectChildren( getInjector() );
			
			excuteCommand( command );
		}

		public function excuteCommand( command : Command ) : void
		{
			command.execute();

			//command not complete after execution
			if ( !command.isComplete )
			{
				command.onComplete.addOnce( onCommandComplete );
			}
		}

		public function addInitCommand( command : Command ) : void
		{
			initializeCommand ||= new SerialCommand();
			initializeCommand.append( command );
		}
		
		private function handleInitCommandComplete( command : CompositeCommand ) : void
		{
			initializeCommand = null;
		}
		
		private function onCommandComplete( command : Command ) : void
		{
			command.destroy();

		}

		override public function destroy() : void
		{
			super.destroy();
			commandMap.destroy();
		}
	}
}
