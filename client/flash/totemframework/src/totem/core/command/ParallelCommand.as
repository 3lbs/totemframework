package totem.core.command
{
	import totem.data.InListIterator;

	public class ParallelCommand extends CompositeCommand
	{

		private var _idle : Boolean = true;

		private var _commandCounter : int;

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
						command.onComplete.addOnce( onCommandComplete );
						commandManager.executeCommand( command );
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

		private function onCommandComplete( command : Command ) : void
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
