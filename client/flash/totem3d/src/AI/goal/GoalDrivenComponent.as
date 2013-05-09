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

package AI.goal
{

	import AI.pathfinding.PathPlanner;

	import totem.core.state.Machine;
	import totem.core.time.TickedComponent;

	public class GoalDrivenComponent extends TickedComponent
	{

		public static const NAME : String = "GoalDrivenComponent";

		private var _currentBrain : GoalThink;

		private var _pathPlanner : PathPlanner;

		public function GoalDrivenComponent( machine : Machine, planner : PathPlanner )
		{
			super( machine );

			_pathPlanner = planner;
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

		public function get pathPlanner() : PathPlanner
		{
			return _pathPlanner;
		}

		override protected function onAdd() : void
		{
			super.onAdd();

		}
	}
}

