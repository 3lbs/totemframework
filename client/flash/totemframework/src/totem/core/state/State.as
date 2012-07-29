package totem.core.state
{
	import totem.core.TotemObject;

	public class State
	{
		/** @private */
		internal var stateMachine : StateMachine;

		public function State()
		{
		}

		public function enter() : void
		{
		}

		public function update( dt : Number ) : void
		{
		}

		public function exit() : void
		{
		}

		protected final function goto( state : State ) : void
		{
			stateMachine.setState( state );
		}
	}
}
