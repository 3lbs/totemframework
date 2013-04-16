package totem.core.mvc.controller.api
{

	import org.swiftsuspenders.Injector;
	
	import totem.core.Destroyable;
	import totem.core.mvc.controller.command.Command;
	import totem.data.InList;
	import totem.data.InListIterator;

	public class StaticCommandMap extends Destroyable
	{

		private var commandList : InList;

		private var injector : Injector;

		public function StaticCommandMap( injector : Injector )
		{
			this.injector = injector;

			commandList = new InList();
		}

		public function mapCommand( command : Command ) : void
		{
			commandList.pushBack( command );
			injector.injectInto( command );
		}

		public function execute() : void
		{
			var iter : InListIterator = commandList.getIterator();

			var command : Command;

			while ( command = iter.data())
			{
				command.execute();
				iter.next();
			}
		}

		override public function destroy() : void
		{
			super.destroy();

			var iter : InListIterator = commandList.getIterator();

			var command : Command;

			while ( iter.hasNext())
			{
				command = iter.data();
				command.destroy();
				iter.remove();
			}

			injector = null;

		}
	}
}
