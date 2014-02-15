//------------------------------------------------------------------------------
//
//     _______ __ __           
//    |   _   |  |  |--.-----. 
//    |___|   |  |  _  |__ --| 
//     _(__   |__|_____|_____| 
//    |:  1   |                
//    |::.. . |                
//    `-------'      
//                       
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.components.commands
{

	import flash.events.IEventDispatcher;
	import totem.core.TotemComponent;
	import totem.core.TotemEntity;
	import totem.core.mvc.controller.api.ICommandMap;
	import totem.core.mvc.controller.api.SignalCommandMap;
	import totem.core.mvc.controller.command.Command;
	import totem.core.mvc.controller.command.SerialCommand;
	import totem.monitors.promise.Deferred;
	import totem.monitors.promise.IPromise;

	import totem.totem_internal;

	use namespace totem_internal;

	public class CommandComponent extends TotemComponent
	{
		private var _commandMap : ICommandMap;

		private var monitor : Deferred;

		public function CommandComponent( name : String = null )
		{
			super( name );
		}

		public function addCommand( command : *, notifType : String ) : void
		{

		}

		public function get commandMap() : ICommandMap
		{
			return _commandMap;
		}

		override public function destroy() : void
		{
			super.destroy();
			commandMap.destroy();
		}

		public function excuteCommand( command : * ) : void
		{
			commandMap.executeCommand( command );
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			_commandMap = new SignalCommandMap( getInjector());

			injector.map( ICommandMap ).toValue( commandMap );

			//owner.onAddSignal.addOnce( doInitialize );
		}

		override protected function onRemove() : void
		{
			super.onRemove();
			destroy();
		}
	}
}
