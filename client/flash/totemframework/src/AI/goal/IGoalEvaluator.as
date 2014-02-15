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

	public interface IGoalEvaluator
	{
		function calculateDesirability( entity : TweenComponent ) : Number;

		function setGoal( entity : TweenComponent ) : void;
	}
}

