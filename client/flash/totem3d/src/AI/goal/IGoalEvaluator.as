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

	public interface IGoalEvaluator
	{
		function calculateDesirability( entity : TotemEntity ) : Number;

		function setGoal( entity : TotemEntity ) : void;
	}
}

