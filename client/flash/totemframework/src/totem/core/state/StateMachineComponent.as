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

		protected var _stateMachine : Machine;

		public function StateMachineComponent( machine : Machine )
		{
			_stateMachine = machine;
		}

		override public function onTick() : void
		{
			if ( activated )
				_stateMachine.tick();
		}

		public function get stateMachine() : Machine
		{
			return _stateMachine;
		}

		override protected function onActivate() : void
		{
			super.onActivate();

			_stateMachine.reset();
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			_stateMachine.setInjector( getInjector().createChildInjector());
			_stateMachine.initialize();
		}

		override protected function onRemove() : void
		{
			super.onRemove();

		}

		override protected function onRetire() : void
		{
			super.onRetire();
			_stateMachine.reset();
		}
	}
}
