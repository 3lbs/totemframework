
package totem.core.state
{

	import flash.utils.Dictionary;

	import ladydebug.Logger;

	/**
	 * Implementation of IMachine; probably any custom FSM would be based on this.
	 *
	 * @see IMachine for API docs.
	 */
	public class Machine implements IMachine
	{
		/**
		 * Set of states, indexed by name.
		 */
		public var states : Dictionary = new Dictionary();

		/**
		 * What state will we start out in?
		 */
		public var defaultState : String = null;

		private var _currentState : IState = null;

		private var _previousState : IState = null;

		private var _setNewState : Boolean = false;

		private var _enteredStateTime : Number = 0;

		/**
		 * Virtual time at which we entered the state.
		 */
		public function get enteredStateTime() : Number
		{
			return _enteredStateTime;
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

		public function getCurrentState() : IState
		{
			// DefaultState - we get it if no state is set.
			if ( !_currentState )
				setCurrentState( defaultState );

			return _currentState;
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

		public function getPreviousState() : IState
		{
			return _previousState;
		}

		public function addState( name : String, state : IState ) : void
		{
			states[ name ] = state;
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

	}
}
