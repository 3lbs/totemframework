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

package totem.core.state
{

	import flash.utils.Dictionary;

	import ladydebug.Logger;

	import totem.core.Destroyable;
	import totem.core.TotemEntity;

	/**
	 * Implementation of IMachine; probably any custom FSM would be based on this.
	 *
	 * @see IMachine for API docs.
	 */
	public class Machine extends Destroyable implements IMachine
	{

		/**
		 * What state will we start out in?
		 */
		public var defaultState : String = null;

		/**
		 * Set of states, indexed by name.
		 */
		public var states : Dictionary = new Dictionary();

		private var _currentState : IState = null;

		private var _enteredStateTime : Number = 0;

		private var _owner : TotemEntity

		private var _previousState : IState = null;

		private var _setNewState : Boolean = false;

		public function Machine( ... initStates )
		{

		}

		public function addState( name : String, state : IState ) : void
		{
			states[ name ] = state;
		}

		public function get currentState() : IState
		{
			return getCurrentState();
		}

		public function get currentStateName() : String
		{
			return getStateName( getCurrentState());
		}

		public function set currentStateName( value : String ) : void
		{
			if ( !setCurrentState( value ))
				Logger.warn( this, "set currentStateName", "Could not transition to state '" + value + "'" );
		}

		/**
		 * Virtual time at which we entered the state.
		 */
		public function get enteredStateTime() : Number
		{
			return _enteredStateTime;
		}

		public function getCurrentState() : IState
		{
			// DefaultState - we get it if no state is set.
			if ( !_currentState )
				setCurrentState( defaultState );

			return _currentState;
		}

		public function getPreviousState() : IState
		{
			return _previousState;
		}

		public function getState( name : String ) : IState
		{
			return states[ name ] as IState;
		}

		public function getStateName( state : IState ) : String
		{
			for ( var name : String in states )
				if ( states[ name ] == state )
					return name;

			return null;
		}

		public function get owner() : TotemEntity
		{
			return _owner;
		}

		public function set owner( value : TotemEntity ) : void
		{
			if ( _owner )
				return;

			_owner = value;
		}

		public function setCurrentState( name : String ) : Boolean
		{
			var newState : IState = getState( name );

			if ( !newState )
				return false;

			var oldState : IState = _currentState;
			_setNewState = true;

			_previousState = _currentState;
			_currentState = newState;

			// Old state gets notified it is changing out.
			if ( oldState )
				oldState.exit( this );

			// New state finds out it is coming in.    
			newState.enter( this );

			return true;
		}

		public function tick() : void
		{
			_setNewState = false;

			// DefaultState - we get it if no state is set.
			if ( !_currentState )
				setCurrentState( defaultState );

			if ( _currentState )
				_currentState.tick( this );

			// If didn't set a new state, it counts as transitioning to the
			// current state. This updates prev/current state so we can tell
			// if we just transitioned into our current state.
			if ( _setNewState == false && _currentState )
			{
				_previousState = _currentState;
			}
		}
	}
}
