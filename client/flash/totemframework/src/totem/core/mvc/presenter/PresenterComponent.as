package totem.core.mvc.presenter
{
	import flash.utils.Dictionary;
	
	import totem.core.TotemComponent;
	import totem.core.mvc.controller.command.Command;

	public class PresenterComponent extends TotemComponent
	{
		private var commandMap : Dictionary;

		public function PresenterComponent( name : String = null )
		{
			super( name );
		}

		public function registerCommand( command : Command ) : void
		{
			commandMap ||= new Dictionary();
			
			
		}
	}
}
