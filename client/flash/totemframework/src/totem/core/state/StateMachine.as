package totem.core.state
{
	import totem.core.TotemObject;

	public class StateMachine extends TotemObject
	{
		private var inTransition_ : Boolean = false;

		private var nextState_ : State = null;

		private var currentState_ : State = null;

		public function StateMachine( initState : State, name : String = null )
		{
			nextState_ = initState;
			
			super( name );
		}

		public function update( dt : Number ) : void
		{
			if ( nextState_ && nextState_ != currentState_ )
			{
				//exit current state
				if ( currentState_ )
				{
					currentState_.exit();
					currentState_.stateMachine = null;

					//currentState_.owningGroup = this.owningGroup;

						//currentState_.setInjector(null);
				}

				//set new current state
				currentState_ = nextState_;

				//initialize current state
				currentState_.stateMachine = this;
				//currentState_.owningGroup = this.owningGroup;

				//currentState_.setInjector(getInjector());
				//currentState_.getInjector().injectInto( currentState_ );
				currentState_.enter();

				//make next state null
				nextState_ = null;
			}

			//update current state
			if ( currentState_ )
				currentState_.update( dt );
		}

		public function setState( nextState : State ) : void
		{
			nextState_ = nextState;
		}

		/** @private */
		internal function dispose() : void
		{
			if ( currentState_ )
			{
				currentState_.exit();
				currentState_ = null;
			}
		}
	}
}
