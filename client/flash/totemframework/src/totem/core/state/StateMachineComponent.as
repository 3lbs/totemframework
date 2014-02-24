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

	import totem.totem_internal;
	import totem.core.time.TickedComponent;

	public class StateMachineComponent extends TickedComponent
	{

		use namespace totem_internal;

		private var _stateMachine : Machine;

		public function StateMachineComponent( machine : Machine )
		{
			_stateMachine = machine;
		}

		public function get stateMachine():Machine
		{
			return _stateMachine;
		}

		override public function onTick() : void
		{
			if ( activated )
				_stateMachine.tick();
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			_stateMachine.setInjector( getInjector().createChildInjector());
			_stateMachine.initialize();
		}
		
		override protected function onRetire():void
		{
			super.onRetire();
			_stateMachine.reset();
		}

		override protected function onRemove() : void
		{
			super.onRemove();

		}
	}
}
