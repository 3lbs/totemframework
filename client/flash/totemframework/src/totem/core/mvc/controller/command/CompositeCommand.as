package totem.core.mvc.controller.command
{
	import org.swiftsuspenders.Injector;
	
	import totem.core.mvc.controller.api.ICommandMap;

	internal class CompositeCommand extends Command
	{
		internal var childrenCommands : Array = [];

		public function CompositeCommand( commands : Array )
		{
			for ( var i : int = 0, len : int = commands.length; i < len; ++i )
			{
				append( commands[ i ]);
			}
		}

		internal var commandManager :  ICommandMap;

		[Inject]
		public function injectManager( commandManager : ICommandMap ) : void
		{
			this.commandManager = commandManager;
		}

		public function append( command : Command ) : void
		{
			childrenCommands.push( command );
		}

		[Inject]
		override internal function injectChildren( injector : Injector ) : void
		{
			for ( var i : int = 0, len : int = childrenCommands.length; i < len; ++i )
			{
				var command : Command = childrenCommands[ i ];
				injector.injectInto( command );
				command.injectChildren( injector );
			}
		}
	}
}
