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

	import flash.utils.Dictionary;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import totem.totem_internal;
	import totem.core.TotemComponent;

	use namespace totem_internal;

	public class StaticCommandComponent extends TotemComponent
	{

		public static const NAME : String = "StaticCommandClass";

		public var commandDispatch : ISignal = new Signal( Class );

		private var _defferredMapCommand : Dictionary = new Dictionary()

		private var commandMap : StaticCommandMap;

		public function StaticCommandComponent()
		{
			super( NAME );

			commandDispatch.add( executeCommand );
		}

		override public function destroy() : void
		{
			super.destroy();

			commandMap.destroy();
			commandMap = null;

			commandDispatch.removeAll();
			commandDispatch = null;
		}

		public function mapCommand( command : StaticCommand, clazz : Class ) : void
		{
			if ( !commandMap )
			{
				_defferredMapCommand[ clazz ] = command;
			}
			else
			{
				commandMap.mapCommand( command, clazz );
			}
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			commandMap = new StaticCommandMap();

			commandMap.setInjector( getInjector().createChildInjector());
			commandMap.initialize();
			
			applyDefferedCommands();
			
			
		}

		private function applyDefferedCommands() : void
		{
			for ( var key : Class in _defferredMapCommand )
			{
				mapCommand( _defferredMapCommand[ key ], key );
				_defferredMapCommand[ key ] = null;
				delete _defferredMapCommand[ key ];
			}
		}

		private function executeCommand( type : Class ) : void
		{
			commandMap.executeCommand( type );
		}
	}
}
