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
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package AI.goal
{

	import totem.core.state.Machine;
	import totem.core.time.TickedComponent;

	public class GoalDrivenComponent extends TickedComponent
	{

		public static const NAME : String = "GoalDrivenComponent";

		private var _currentBrain : GoalThink;

		public function GoalDrivenComponent( machine : Machine )
		{
			super( machine );
		}

		public function get brain() : GoalThink
		{
			return _currentBrain;
		}

		public function set brain( value : GoalThink ) : void
		{
			_currentBrain = value;
		}

		override public function onTick() : void
		{
			if ( _currentBrain )
				_currentBrain.process();

		}

		override protected function onAdd() : void
		{
			super.onAdd();

			
		}
	}
}

