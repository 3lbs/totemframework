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

package totem.core.state
{

	import flash.utils.Dictionary;
	
	import ladydebug.Logger;
	
	import totem.totem_internal;
	import totem.core.Injectable;
	import totem.utils.DestroyUtil;

	/**
	 * Implementation of IMachine; probably any custom FSM would be based on this.
	 *
	 * @see IMachine for API docs.
	 */
	public class Machine extends Injectable implements IMachine
	{

		use namespace totem_internal;

		/**
		 * What state will we start out in?
		 */
		public var defaultState : String = null;

		/**
		 * Set of states, indexed by name.
		 */
		public var states : Dictionary = new Dictionary();

		private var _currentState : IState = null;

		private var _previousState : IState = null;

		private var _setNewState : Boolean = false;

		public function Machine()
		{
		}

		public function addState( name : String, state : IState ) : IMachine
		{
			states[ name ] = state;

			if ( initialzed )
			{
				getInjector().injectInto( state );
			}

			State( state ).stateMachine = this;

			return this;
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

		override public function destroy() : void
		{
			super.destroy();

			DestroyUtil.destroyDictionary( states );
			states = null;

			_currentState = null;
			_previousState = null;
		}

		public function getCurrentState() : IState
		{
			// DefaultState - we get it if no state is set.
			if ( !_currentState )
			{
				if ( !defaultState )
					return null;

				setCurrentState( defaultState );
			}

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

		public function goToPreviousState() : Boolean
		{
			if ( _previousState )
			{
				var name : String = getStateName( _previousState );
				setCurrentState( name );
				return true;
			}
			return false;
		}

		override public function initialize() : void
		{
			super.initialize();

			for each ( var state : IState in states )
			{
				getInjector().injectInto( state );
			}
		}

		public function reset() : void
		{
			_currentState = null;
			_previousState = null;
		}

		public function setCurrentState( name : String ) : Boolean
		{
			var _newState : IState = getState( name );

			if ( !_newState )
			{
				throw new Error( "State named:", name );
				return false;

			}

			var oldState : IState = _currentState;
			_setNewState = true;

			_previousState = _currentState;
			_currentState = _newState;

			// Old state gets notified it is changing out.
			if ( oldState )
				oldState.exit( this );

			// New state finds out it is coming in.    
			_newState.enter( this );

			return true;
		}

		public function tick() : void
		{
			_setNewState = false;

			// DefaultState - we get it if no state is set.
			if ( !_currentState && defaultState )
			{
				setCurrentState( defaultState );
			}

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
