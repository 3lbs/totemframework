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

	import totem.core.TotemEntity;

	public class GoalEvaluator implements IGoalEvaluator
	{
		public var characterBias : Number;

		protected var desirability : Number;

		public function GoalEvaluator( bias : Number )
		{
			characterBias = bias;
		}

		public function calculateDesirability( entity : TotemEntity ) : Number
		{
			return 0;
		}

		public function setGoal( entity : TotemEntity ) : void
		{

		}
	}
}

