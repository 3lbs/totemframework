package totem.core.mvc.presenter
{
	import flash.utils.Dictionary;

	import flight.domain.Command;

	import totem.core.TotemComponent;

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
