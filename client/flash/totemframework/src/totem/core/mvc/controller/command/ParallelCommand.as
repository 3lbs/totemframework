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
//   3lbs Copyright 2013 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.core.mvc.controller.command
{

	import totem.totem_internal;

	use namespace totem_internal;

	public class ParallelCommand extends CompositeCommand
	{

		private var _commandCounter : int;

		private var _idle : Boolean = true;

		public function ParallelCommand( ... subcommands )
		{
			super( subcommands );
		}

		override public function execute() : void
		{
			if ( _idle )
			{
				if ( childrenCommands.length )
				{
					_commandCounter = 0;
					var command : Command;

					for ( var i : int = 0, len : int = childrenCommands.length; i < len; ++i )
					{
						command = childrenCommands[ i ];

						if ( command is AsyncCommand )
							AsyncCommand( command ).onComplete.addOnce( onCommandComplete );

						//commandManager.executeCommand( command );

						command.execute();
						
						if ( !command is AsyncCommand )
							onCommandComplete( command );
					}
					_idle = false;
				}
				else
				{
					//zero command
					complete();
				}
			}
		}

		private function onCommandComplete( success : Boolean ) : void
		{
			++_commandCounter;

			if ( _commandCounter == childrenCommands.length )
			{
				complete();
				_idle = true;
			}
		}
	}
}
