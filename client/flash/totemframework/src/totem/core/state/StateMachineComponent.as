package totem.core.state
{
	import totem.core.TotemComponent;
	import totem.data.InListIterator;

	public class StateMachineComponent extends TotemComponent
	{
		private var initStates_ : Array;
		
		private var stateMachines : StateMachineCollector;
		
		public function StateMachineComponent( ... initStates )
		{
			initStates_ = initStates;
		}

		public function onAdded() : void
		{
			var system : StateMachineSystem = getSystem( StateMachineSystem );
			system.register( this );

			for ( var i : int = 0, len : int = initStates_.length; i < len; ++i )
			{
				stateMachines.add( new StateMachine( initStates_[ i ]));
			}
		}

		public function onRemoved() : void
		{
			/*var iter : InListIterator = stateMachines_.getIterator();
			var stateMachine : StateMachine;

			while ( stateMachine = iter.data())
			{
				stateMachine.dispose();
				iter.next();
			}

			var system : StateMachineSystem = getSystem( StateMachineSystem );
			system.unregister( this );*/
		}

		/** @private */
		internal function update( dt : Number ) : void
		{
			/*var iter : InListIterator = stateMachines_.getIterator();
			var stateMachine : StateMachine;

			while ( stateMachine = iter.data())
			{
				stateMachine.update( dt );
				iter.next();
			}*/
		}
	}
}
