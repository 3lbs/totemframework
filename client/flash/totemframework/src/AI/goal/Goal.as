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

	import flash.events.Event;

	import totem.components.motion.TweenComponent;
	import totem.core.Destroyable;

	public class Goal
	{
		public static const ACTIVE : int = 10;

		public static const COMPLETED : int = 30;

		public static const FAILED : int = 40;

		public static const INACTIVE : int = 20;

		public var owner : TweenComponent;

		protected var _interruptible : Boolean = true;

		protected var subgoals : Vector.<Goal>;

		private var _status : int;

		public function Goal( owner : TweenComponent )
		{
			this.owner = owner;

			status = INACTIVE;

			subgoals = new Vector.<Goal>();
		}

		public function activate() : void
		{
			status = ACTIVE;

		}

		public function activateIfInactive() : void
		{
			if ( isInactive())
			{
				activate();
			}
		}

		public function addSubgoal( goal : Goal ) : void
		{

			if ( !goal )
				return;

			subgoals.push( goal );
		}


		public function hasFailed() : Boolean
		{
			return status == FAILED;
		}

		public function get interruptible() : Boolean
		{
			return _interruptible;
		}

		public function isActive() : Boolean
		{
			return status == ACTIVE;
		}

		public function isCompleted() : Boolean
		{
			return status == COMPLETED;
		}

		public function isInactive() : Boolean
		{
			return status == INACTIVE;
		}

		public function process() : int
		{
			return status;
		}

		public function reactivateIfFailed() : void
		{
			if ( hasFailed())
			{
				status = INACTIVE;
			}
		}

		public function removeAllSubgoals() : void
		{
			while ( subgoals.length )
				subgoals.pop().terminate();

			subgoals.length = 0;
		}

		public function get status() : int
		{
			return _status;
		}

		public function set status( value : int ) : void
		{
			_status = value;
		}

		public function terminate() : void
		{
			removeAllSubgoals();
			
			subgoals = null;
			owner = null;
		}

		protected function forwardMessageToFirstSubGoal( event : Event ) : Boolean
		{
			if ( subgoals.length > 0 )
			{
				return subgoals[ 0 ].handleMessage( event );
			}
			return false;
		}
	}
}

