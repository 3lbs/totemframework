
package totem.core.mvc.controller.command
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import totem.core.TotemComponent;
	import totem.core.mvc.controller.api.ICommandMap;
	import totem.totem_internal;

	use namespace totem_internal;

	public class ControllerComponent extends TotemComponent
	{
		public var eventDispatcher : IEventDispatcher;

		private var commandMap : ICommandMap;

		private var initializeCommand : CompositeCommand;

		private var singletonCommandMap : Dictionary;
		
		public function ControllerComponent( name : String = null )
		{
			super( name );
		}

		override protected function onAdd() : void
		{
			super.onAdd();
			
			commandMap = new SignalCommandMap( getInjector() );
				
			if ( initializeCommand )
			{
				excuteCommand( initializeCommand );
				initializeCommand.onComplete.addOnce( handleInitCommandComplete );
			}
		}
	
		override protected function onRemove() : void
		{
			super.onRemove();
			destroy();
		}
		
		public function excuteCommand( command : * ) : void
		{
			commandMap.executeCommand( command );
		}

		public function addInitCommand( command : Command ) : void
		{
			initializeCommand ||= new SerialCommand();
			initializeCommand.append( command );
		}
		
		private function handleInitCommandComplete( command : Command ) : void
		{
			initializeCommand = null;
		}

		override public function destroy() : void
		{
			super.destroy();
			commandMap.destroy();
		}
	}
}
