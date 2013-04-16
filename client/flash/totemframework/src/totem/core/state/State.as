package totem.core.state
{
	

	public class State implements IState
	{
		/** @private */
		internal var stateMachine : Machine;

		public function State()
		{
		}

		public function enter( fsm : IMachine ) : void
		{
		}

		public function tick( fsm : IMachine ) : void
		{
		}

		public function exit( fsm : IMachine ) : void
		{
		}

		protected final function gotoState( value : String ) : void
		{
			stateMachine.setCurrentState( value );
		}
	}
}
