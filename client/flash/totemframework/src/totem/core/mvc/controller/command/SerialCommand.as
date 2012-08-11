package totem.core.mvc.controller.command
{
	import totem.data.InListIterator;

	public class SerialCommand extends CompositeCommand
	{

		private var _idle : Boolean = true;

		private var _index : int;

		public function SerialCommand( ... subcommands )
		{
			super( subcommands );
		}

		override public function execute() : void
		{
			if ( _idle )
			{
				if ( childrenCommands.length )
				{
					_index = 0;
					_idle = false;

					var command : Command = childrenCommands[ 0 ];
					command.onComplete.addOnce( onCommandComplete );
					commandManager.executeCommand( command );
				}
				else
				{
					//zero command
					complete();
				}
			}
		}

		protected function onCommandComplete( command : Command ) : void
		{
			++_index;

			if ( _index == childrenCommands.length )
			{
				complete();
				_idle = true;
			}
			else
			{
				var command : Command = childrenCommands[ _index ];
				command.onComplete.addOnce( onCommandComplete );
				commandManager.executeCommand( command );
			}
		}
	}
}
