package totem.core.mvc.controller.command
{
	import flash.events.IEventDispatcher;
	
	import totem.core.System;
	import totem.core.mvc.TotemContext;
	import totem.core.mvc.controller.api.ICommandMap;

	public class ControllerSystemManager extends System
	{

		/** @private */
		private var _instance : TotemContext;
		
		public var eventDispatcher : IEventDispatcher;
		
		private var commandMap : ICommandMap;

		public function ControllerSystemManager( instance : TotemContext )
		{
			super();
			_instance = instance;
		}
		
		public function excuteCommand( command : * ) : void
		{
			commandMap.executeCommand( command );
		}
	}
}
