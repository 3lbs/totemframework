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
	import totem.core.Injectable;

	import totem.totem_internal;
	import totem.utils.DestroyUtil;

	public class StaticCommandMap extends Injectable
	{

		use namespace totem_internal;

		private var commands : Dictionary = new Dictionary();

		private var injector : Injector;

		public function StaticCommandMap()
		{
		}

		override public function destroy() : void
		{
			super.destroy();

			DestroyUtil.destroyDictionary( commands );
			commands = null;

			injector = null;
		}

		public function executeCommand( clazz : Class, ... args ) : void
		{
			var command : *;

			if (( command = commands[ clazz ]) != null )
			{

				if ( !args )
				{
					command.execute.call();
					return;
				}

				switch ( args.length )
				{
					case 0:
						command.execute.call();
						break;
					case 1:
						command.execute( args[ 0 ]);
						break;
					case 2:
						command.execute( args[ 0 ], args[ 1 ]);
						break;
					case 3:
						command.execute( args[ 0 ], args[ 1 ], args[ 2 ]);
						break;
					default:
						command.execute.apply( null, args );
				}
			}
		}

		public function mapCommand( command : *, clazz : Class ) : void
		{
			commands[ clazz ] = command;

			if ( injector )
			{
				injector.injectInto( command );
				command.intialize();
			}
		}

		override public function setInjector( injector : Injector ) : void
		{
			super.setInjector( injector );

			for each ( var command : Object in commands )
			{
				injector.injectInto( command );
			}
		}
	}
}
