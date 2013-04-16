package totem.core.mvc.controller.command
{
	import totem.totem_internal;
	

	use namespace totem_internal;
	
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
					if ( command is AsyncCommand )
						AsyncCommand ( command ).onComplete.addOnce( onCommandComplete );
					
					//commandManager.executeCommand( command );
					
					command.execute();
					
					if ( !command is AsyncCommand )
						onCommandComplete( command );
				}
				else
				{
					//zero command
					complete();
				}
			}
		}

		protected function onCommandComplete( success : Boolean ) : void
		{
			++_index;

			if ( _index == childrenCommands.length || success == false )
			{
				complete();
				_idle = true;
			}
			else
			{
				var command : Command = childrenCommands[ _index ];
				
				if ( command is AsyncCommand )
					AsyncCommand( command ).onComplete.addOnce( onCommandComplete );
	
				command.execute();
				//commandManager.executeCommand( command );
				
				if ( !command is AsyncCommand )
					onCommandComplete( true );
			}
		}
	}
}
