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
	import totem.components.commands.StaticCommandMap;
	import totem.core.time.TickedComponent;

	import totem.totem_internal;

	public class GoalDrivenComponent extends TickedComponent
	{

		use namespace totem_internal;

		public static const NAME : String = "GoalDrivenComponent";

		protected var _commandMap : StaticCommandMap;

		protected var _currentBrain : GoalThink;

		protected var _pathPlanner : AStarPathPlanner;

		protected var processBrain : Boolean;

		public function GoalDrivenComponent( machine : StaticCommandMap, planner : AStarPathPlanner )
		{
			super( NAME );

			_pathPlanner = planner;
			_commandMap = machine;
		}

		public function get brain() : GoalThink
		{
			return _currentBrain;
		}

		public function set brain( value : GoalThink ) : void
		{
			_currentBrain = value;
		}

		public function commandMap() : StaticCommandMap
		{
			return _commandMap;
		}

		override public function onTick() : void
		{
			if ( _currentBrain && processBrain )
			{
				_currentBrain.process();
			}
		}

		public function get pathPlanner() : AStarPathPlanner
		{
			return _pathPlanner;
		}

		override protected function onActivate() : void
		{
			super.onActivate();

			processBrain = true;
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			_commandMap.setInjector( getInjector().createChildInjector());
			_commandMap.initialize();
		}

		override protected function onRemove() : void
		{

			super.onRemove();

			_pathPlanner = null;

			_commandMap.destroy();

			_commandMap = null;

		}

		override protected function onRetire() : void
		{
			super.onRetire();

			processBrain = false;

			if ( _currentBrain )
			{
				_currentBrain.removeAllSubgoals();
			}
		}
	}
}

