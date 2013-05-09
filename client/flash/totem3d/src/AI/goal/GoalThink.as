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

	import avmplus.getQualifiedClassName;
	
	import totem.core.TotemEntity;

	public class GoalThink extends GoalComposite
	{
		public static const TYPE : String = "Brain";

		protected var evaluators : Vector.<IGoalEvaluator>;

		public function GoalThink( owner : TotemEntity )
		{
			super( TYPE, owner );

			evaluators = new Vector.<IGoalEvaluator>();
		}

		override public function activate() : void
		{
			super.activate();
			arbitrate();
		}

		public function addEvaluators( evaluator : GoalEvaluator ) : void
		{
			evaluators.push( evaluator );
		}
		
		//----------------------------- Update ----------------------------------------
		// 
		//  this method iterates through each goal option to determine which one has
		//  the highest desirability.
		//-----------------------------------------------------------------------------
		
		/**
		 * 
		 * this method iterates through each goal option to determine which one has
		 * the highest desirability.
		 * 
		 */
		public function arbitrate() : void
		{
			var best : Number = 0;
			var mostDesirable : IGoalEvaluator;
			var i : int = 0;
			var l : int = evaluators.length;
			var desirablity : Number = 0;

			for ( i = 0; i < l; ++i )
			{
				desirablity = evaluators[ i ].calculateDesirability( owner );

				if ( desirablity >= best )
				{
					best = desirablity;
					mostDesirable = evaluators[ i ];
				}
			}

			if ( mostDesirable )
			{
				mostDesirable.setGoal( owner );
			}
		}

		override public function destroy() : void
		{
			super.destroy();

			evaluators.length = 0;

		}

		override public function process() : int
		{
			activateIfInactive();
			var subgoalStatus : int = processSubgoals();

			if ( subgoalStatus == COMPLETED || subgoalStatus == FAILED )
			{
				status = INACTIVE;
			}

			return status;
		}

		
		public function addGoal ( goal : Goal ) : Boolean
		{
			if ( notPresent( goal  ) )
			{
				removeAllSubgoals();
				addSubgoal( goal );
			}
			return false;
		}
		
		protected function notPresent( goal : Goal ) : Boolean
		{
			if ( subgoals.length > 0 )
			{
				return false; //subgoals.indexOf( goal ) != -1;
			}

			return true;
		}
	}
}

