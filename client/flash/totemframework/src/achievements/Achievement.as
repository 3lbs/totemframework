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

package achievements
{

	import totem.events.RemovableEventDispatcher;

	public class Achievement extends RemovableEventDispatcher
	{

		// user has read the quest now can perform it
		public static const STATE_ACTIVE : int = 2;

		// save to database and closed forever
		public static const STATE_CLOSED : int = 4;

		// user completed the task award them!
		public static const STATE_COMPLETED : int = 3;

		// locked and hidden
		public static const STATE_HIDDEN : int = 0;

		// user can read the quest
		public static const STATE_VISIBLE : int = 1;

		public var localeCompleteKey : String;

		public var localeIntroKey : String;

		public var localeTitleKey : String;

		public var nodes : Vector.<String>;

		public var parent : Achievement;

		public var properties : Vector.<AchieveProperty> = new Vector.<AchieveProperty>();

		public var required : Vector.<String>;

		public var rewards : Vector.<AchievementReward>;

		private var _children : Vector.<Achievement>;

		private var _force : Boolean;

		private var _id : String;

		private var _state : int;

		public function Achievement()
		{

			_children = new Vector.<Achievement>();
		}

		public function get active() : Boolean
		{
			return _state == STATE_ACTIVE;
		}

		public function addChild( a : Achievement ) : Achievement
		{
			a.parent = this;
			_children.push( a );

			return a;
		}

		public function addProperties( p : AchieveProperty ) : void
		{
			properties.push( p );
		}

		public function get closed() : Boolean
		{
			return _state == STATE_CLOSED
		}

		[Transient]
		public function get completed() : Boolean
		{
			return _state == STATE_COMPLETED;
		}

		override public function destroy() : void
		{
			nodes.length = 0;
			nodes = null;

			parent = null;

			properties.length = 0;
			properties = null;

			rewards.length = 0;
			rewards = null;

			_children.length = 0;
			_children = null;

			super.destroy();
		}

		public function forceComplete() : void
		{
			_force = true;
		}

		public function getAchievementByID( id : String ) : Achievement
		{

			if ( _id == id )
			{
				return this;
			}

			var child : Achievement;
			var l : int = _children.length;

			if ( l > 0 )
			{
				var i : int;

				for ( i = 0; i < l; i++ )
				{
					child = _children[ i ].getAchievementByID( id );

					if ( child )
					{
						return child;
					}
				}
			}

			return child;
		}

		public function getChildren() : Vector.<Achievement>
		{
			return _children;
		}

		public function getLocalize() : String
		{
			return ( _state == STATE_ACTIVE || _state == STATE_VISIBLE ? localeIntroKey : localeCompleteKey );
		}

		public function getPropertyByID( value : String ) : AchieveProperty
		{
			var l : int = properties.length;

			while ( l-- )
			{
				if ( properties[ l ].propID == value )
				{
					return properties[ l ];
				}
			}

			return null;
		}

		public function get hidden() : Boolean
		{
			return _state == STATE_HIDDEN;
		}

		public function get id() : String
		{
			return _id;
		}

		public function set id( value : String ) : void
		{
			_id = value;
		}

		public function get state() : int
		{
			return _state;
		}

		public function get visible() : Boolean
		{
			return _state == STATE_VISIBLE;
		}

		internal function checkDependencyCompleted() : Boolean
		{

			if ( !parent )
			{
				return true;
			}

			var quest : Achievement;
			var i : int = required.length;

			while ( i-- )
			{
				if (( quest = parent.getChildByID( required[ i ])) && !quest.completed )
				{
					return false;
				}
			}

			return true;
		}

		internal function checkPropertiesActivated() : Boolean
		{
			var i : int = properties.length;

			while ( i-- )
			{
				if ( !properties[ i ].isActivated())
				{
					return false
				}
			}
			return true;
		}

		internal function checkPropertiesComplete() : Boolean
		{

			var i : int = properties.length;

			while ( i-- )
			{
				if ( !properties[ i ].isConditionMet())
				{
					return false;
				}
			}

			return true;
		}

		// these are the only ones you want to run property test against
		internal function getActiveAchievements( result : Vector.<Achievement> = null ) : Vector.<Achievement>
		{
			result ||= new Vector.<Achievement>();

			if ( active )
			{
				result.push( this );

			}
			else if ( completed && _children.length > 0 )
			{
				var l : int = _children.length;
				var i : int;

				for ( i = 0; i < l; i++ )
				{
					result.concat( _children[ i ].getActiveAchievements( result ));
				}
			}

			return result;
		}

		internal function getChildByID( id : String ) : Achievement
		{
			for each ( var child : Achievement in _children )
			{
				if ( child.id == id )
				{
					return child;
				}
			}
			return null;
		}

		internal function getViewableAchievements( result : Vector.<Achievement> = null ) : Vector.<Achievement>
		{
			result ||= new Vector.<Achievement>();

			if ( visible || active || completed )
			{
				result.push( this );
			}

			if (( completed || closed ) && _children.length > 0 )
			{
				var l : int = _children.length;
				var i : int;

				for ( i = 0; i < l; i++ )
				{
					result.concat( _children[ i ].getViewableAchievements( result ));
				}
			}

			return result;
		}
		
		public function setClosed () : void
		{
			_state = STATE_CLOSED;
		}

		public function goToNextState () : void
		{
			switch(_state)
			{
				case STATE_HIDDEN:
				{
					_state = STATE_VISIBLE;	
					break;
				}
				case STATE_VISIBLE:
				{
					_state = STATE_ACTIVE;	
					break;
				}
				case STATE_ACTIVE:
				{
					_state = STATE_COMPLETED;	
					break;
				}
				case STATE_COMPLETED:
				{
					_state = STATE_CLOSED;	
					break;
				}
			}
		}
		
		internal function update() : void
		{
			// try to set state!

			if ( _state != STATE_CLOSED )
			{
				_state = STATE_HIDDEN;

				// everything else visible?  are dependency met
				if ( checkDependencyCompleted())
				{
					_state = STATE_VISIBLE;
				}

				// check props state for active. initial value?
				if ( checkPropertiesActivated())
				{
					_state = STATE_ACTIVE;
				}

				//completed check if all props are complet?
				if ( checkPropertiesComplete() || _force )
				{
					_state = STATE_COMPLETED;
				}
			}

			if ( _children.length > 0 )
			{
				var l : int = _children.length;
				var i : int;

				for ( i = 0; i < l; i++ )
				{
					_children[ i ].update();
				}
			}
		}
	}
}
