package totem.core.state
{

	import totem.core.time.TickedComponent;

	public class StateMachineComponent extends TickedComponent
	{
		private var machine : Machine;

		public function StateMachineComponent( m : Machine )
		{
			machine = m;
		}

		override protected function onAdd() : void
		{
			super.onAdd();
		}

		override protected function onRemove() : void
		{
			super.onRemove();

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

		override public function onTick() : void
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
