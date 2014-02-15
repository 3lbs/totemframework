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
	
	import org.swiftsuspenders.Injector;
	
	import totem.totem_internal;
	import totem.core.Destroyable;
	import totem.core.TotemEntity;
	import totem.utils.DestroyUtil;

	public class StaticCommandMap extends Destroyable
	{

		use namespace totem_internal;

		private var commands : Dictionary = new Dictionary();

		private var injector : Injector;


		public function StaticCommandMap( injector : Injector )
		{
			this.injector = injector;;
		}

		override public function destroy() : void
		{
			super.destroy();

			DestroyUtil.destroyDictionary( commands );
			commands = null;

			injector = null;
		}

		public function executeCommand( clazz : Class ) : void
		{
			if ( hasCommand( clazz ))
			{
				var command : StaticCommand = commands[ clazz ];

				if ( !command.isBusy())
				{
					command.execute();
				}
			}
		}

		public function hasCommand( clazz : Class ) : Boolean
		{
			return commands[ clazz ] != null;
		}

		public function mapCommand( command : StaticCommand, clazz : Class ) : void
		{
			commands[ clazz ] = command;
			injector.injectInto( command );
			command.intialize();
		}
	}
}
