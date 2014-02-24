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

package AI.goal
{

	import AI.pathfinding.AStarPathPlanner;
	import totem.core.state.Machine;
	import totem.core.time.TickedComponent;

	import totem.totem_internal;

	public class GoalDrivenComponent extends TickedComponent
	{

		use namespace totem_internal;

		public static const NAME : String = "GoalDrivenComponent";

		protected var _currentBrain : GoalThink;

		protected var _machine : Machine;

		protected var _pathPlanner : AStarPathPlanner;

		private var _enabled : Boolean = true;

		public function GoalDrivenComponent( machine : Machine, planner : AStarPathPlanner )
		{
			super( NAME );

			_pathPlanner = planner;
			_machine = machine;
		}

		public function get brain() : GoalThink
		{
			return _currentBrain;
		}

		public function set brain( value : GoalThink ) : void
		{
			_currentBrain = value;
		}

		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled( value : Boolean ) : void
		{
			_enabled = value;
		}

		public function machine() : Machine
		{
			return _machine;
		}

		override public function onTick() : void
		{
			if ( _currentBrain && activated && _enabled )
			{
				_currentBrain.process();
			}
		}

		public function get pathPlanner() : AStarPathPlanner
		{
			return _pathPlanner;
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			_machine.setInjector( getInjector().createChildInjector());
			_machine.initialize();
		}

		override protected function onRemove() : void
		{

			super.onRemove();

			_pathPlanner = null;

			_machine.destroy();

			_machine = null;

		}
	}
}

