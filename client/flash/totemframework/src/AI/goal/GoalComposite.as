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

	import totem.components.motion.TweenComponent;

	public class GoalComposite extends Goal
	{

		public function GoalComposite( owner : TweenComponent )
		{
			super( owner );
		}

		override public function canComplete() : Boolean
		{

			var l : int = _gaurds.length;

			while ( l-- )
			{
				if ( _gaurds[ l ].gaurded())
				{
					return false;
				}
			}

			if ( subgoals.length > 0 )
			{
				if ( !subgoals[ 0 ].canComplete())
					return false;
			}

			return true;
		}

		override public function get interruptible() : Boolean
		{
			if ( subgoals.length > 0 )
			{
				if ( subgoals[ 0 ].interruptible == false )
					return false;
			}
			return _interruptible;
		}

		protected function processSubgoals() : int
		{
			var goal : Goal;

			// when u have a group of subgoals you want to remove the completed goals
			while ( subgoals.length > 0 && ( subgoals[ 0 ].isCompleted() || subgoals[ 0 ].hasFailed()))
			{
				goal = subgoals.shift();
				goal.terminate();
			}

			var statusOfSubgoals : int = COMPLETED;

			if ( subgoals.length > 0 )
			{
				statusOfSubgoals = subgoals[ 0 ].process();

				if ( statusOfSubgoals == COMPLETED && subgoals.length > 1 )
				{
					return ACTIVE;
				}
			}

			return statusOfSubgoals;
		}
	}
}

