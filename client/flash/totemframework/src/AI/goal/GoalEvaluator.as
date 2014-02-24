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
	import totem.core.Destroyable;

	public class GoalEvaluator extends Destroyable implements IGoalEvaluator
	{
		public var characterBias : Number;

		protected var desirability : Number;

		public function GoalEvaluator( bias : Number = 1 )
		{
			characterBias = bias;
		}

		public function calculateDesirability( entity : TweenComponent ) : Number
		{
			return 0;
		}

		public function setGoal( entity : TweenComponent ) : void
		{

		}

		internal function setTo( bias : Number ) : void
		{
			characterBias = bias;
		}
	}
}
