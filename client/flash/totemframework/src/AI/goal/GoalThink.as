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

	public class GoalThink extends GoalComposite
	{

		protected var evaluators : Vector.<IGoalEvaluator>;

		public function GoalThink( owner : TweenComponent )
		{
			super( owner );

			evaluators = new Vector.<IGoalEvaluator>();
		}

		override public function activate() : void
		{
			super.activate();
			arbitrate();
		}

		public function addEvaluators( evaluator : GoalEvaluator ) : GoalThink
		{
			evaluators.push( evaluator );

			return this;
		}

		public function addGoal( goal : Goal ) : GoalThink
		{
			if ( subgoals.length > 0 && !interruptible )
				return this;

			if ( notPresent( goal ))
			{
				removeAllSubgoals();
				
				addSubgoal( goal );
			}

			return this;
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
				desirablity = evaluators[ i ].calculateDesirability( ownerSpatial );

				if ( desirablity >= best )
				{
					best = desirablity;
					mostDesirable = evaluators[ i ];
				}
			}

			if ( mostDesirable )
			{
				mostDesirable.setGoal( ownerSpatial );
			}
		}

		override public function terminate():void
		{
			super.terminate();

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

		public function removeEvaluators() : void
		{
			evaluators.length = 0;
		}

		protected function notPresent( goal : Goal ) : Boolean
		{
			if ( subgoals.length > 0 )
			{
				return subgoals.indexOf( goal ) != -1;
			}

			return true;
		}
	}
}

