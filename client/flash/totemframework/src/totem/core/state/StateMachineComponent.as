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
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.core.state
{

	import totem.core.time.TickedComponent;

	import totem.totem_internal;

	public class StateMachineComponent extends TickedComponent
	{

		use namespace totem_internal;

		private var stateMachine : Machine;

		public function StateMachineComponent( machine : Machine )
		{
			stateMachine = machine;
		}

		override public function onTick() : void
		{
			stateMachine.tick();
		}

		override protected function onAdd() : void
		{
			super.onAdd();
			
			stateMachine.setInjector( getInjector().createChildInjector() );
			stateMachine.initialize();
		}

		override protected function onRemove() : void
		{
			super.onRemove();

		}
	}
}
