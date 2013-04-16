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

	import totem.core.TotemEntity;

	public class GoalComposite extends Goal
	{

		public function GoalComposite( type : String, owner : TotemEntity )
		{
			super( type, owner );
		}

		public function processSubgoals() : int
		{
			var goal : GoalComposite;

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

