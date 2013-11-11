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

	import flash.events.Event;
	
	import totem.core.TotemEntity;
	import totem.events.RemovableEventDispatcher;

	public class Goal extends RemovableEventDispatcher
	{
		public static const ACTIVE : int = 10;

		public static const COMPLETED : int = 30;

		public static const FAILED : int = 40;

		public static const INACTIVE : int = 20;

		public var owner : TotemEntity;

		public var type : String;

		protected var subgoals : Vector.<Goal>;

		private var _status : int;

		public function Goal( type : String, owner : TotemEntity )
		{
			this.type = type;
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
			
			subgoals.unshift( goal );
		}

		override public function destroy() : void
		{
			super.destroy();
			
			removeAllSubgoals();

			subgoals = null;
			owner = null;
		}

		public function getType() : String
		{
			return type;
		}

		public function handleMessage( event : Event ) : Boolean
		{

			return false;
		}

		public function hasFailed() : Boolean
		{
			return status == FAILED;
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
			for ( var i : int = 0; i < subgoals.length; ++i )
			{
				subgoals[ i ].terminate();
			}
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
			destroy();
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
