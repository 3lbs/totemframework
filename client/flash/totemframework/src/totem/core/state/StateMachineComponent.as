//------------------------------------------------------------------------------
//
//     _______ __ __           
//    |   _   |  |  |--.-----. 
//    |___|   |  |  _  |__ --| 
//     _(__   |__|_____|_____| 
//    |:  1   |                
//    |::.. . |                
//    `-------'      
//                       
//   3lbs Copyright 2013 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

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

		override public function onTick() : void
		{
			machine.tick();

		/*var iter : InListIterator = stateMachines_.getIterator();
		var stateMachine : StateMachine;

		while ( stateMachine = iter.data())
		{
			stateMachine.update( dt );
			iter.next();
		}*/
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
	}
}
