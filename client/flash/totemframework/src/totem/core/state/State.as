package totem.core.state
{
	import totem.core.command.Command;
	import totem.core.command.utils.Dummy;
	
	public class State //implements IDisposable
	{
		/**
		 * @private
		 */
		internal var stateMachine : StateMachine;
		
		public function State()
		{
		
		}
		
		public function getEnterCommand() : Command
		{
			return new Dummy ();
		}
		
		public function getExitCommand() : Command
		{
			return new Dummy ();
		}
		
		public function onSet() : void
		{
		
		}
		
		public function input( value : * ) : void
		{
		
		}
		
		public function update( dt : Number ) : void
		{
		
		}
		
		protected final function goto( state : State ) : void
		{
			stateMachine.setState ( state );
		}
		
		public function dispose() : void
		{
		
		}
	}
}


