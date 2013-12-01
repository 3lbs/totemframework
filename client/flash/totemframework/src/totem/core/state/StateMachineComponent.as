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

	import org.as3commons.collections.LinkedList;
	import org.as3commons.collections.framework.ILinkedListIterator;
	import totem.core.time.TickedComponent;

	import totem.totem_internal;

	public class StateMachineComponent extends TickedComponent
	{
		//private var machine : Machine;

		use namespace totem_internal;

		private var initStates_ : Array;

		private var stateMachines_ : LinkedList;

		public function StateMachineComponent( ... initStates )
		{
			initStates_ = initStates;
		}

		override public function onTick() : void
		{
			var iter : ILinkedListIterator = stateMachines_.iterator() as ILinkedListIterator;
			var stateMachine : Machine;

			while ( stateMachine = iter.current())
			{
				stateMachine.tick();
			}
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			//var system : StateMachineSystem = getSystem( StateMachineSystem );
			//system.register( this );

			for ( var i : int = 0, len : int = initStates_.length; i < len; ++i )
			{
				stateMachines_.add( new Machine( initStates_[ i ]));
			}
		}

		override protected function onRemove() : void
		{
			super.onRemove();

			var iter : ILinkedListIterator = stateMachines_.iterator() as ILinkedListIterator;
			var stateMachine : Machine;

			while ( stateMachine = iter.current())
			{
				stateMachine.destroy();
				iter.next();
			}

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
