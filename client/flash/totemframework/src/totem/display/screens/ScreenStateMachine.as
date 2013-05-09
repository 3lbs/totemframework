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

package totem.display.screens
{

	import flash.utils.Dictionary;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import totem.display.layout.ScreenComposite;
	import totem.events.RemovableEventDispatcher;

	public class ScreenStateMachine extends RemovableEventDispatcher
	{

		public var completeDispatcher : ISignal = new Signal();

		public var defaultState : String = null;

		public var parentScreen : ScreenComposite;

		public var states : Dictionary = new Dictionary();

		private var _currentState : IScreenState = null;

		private var _previousState : IScreenState = null;

		private var _setNewState : Boolean = false;

		private var queStateName : String;

		public function ScreenStateMachine( screen : ScreenComposite )
		{
			parentScreen = screen;
		}

		public function addState( name : String, state : IScreenState ) : void
		{
			states[ name ] = state;
		}

		public function get currentState() : IScreenState
		{
			return getCurrentState();
		}

		public function get currentStateName() : String
		{
			return getStateName( getCurrentState());
		}

		public function getCurrentState() : IScreenState
		{
			// DefaultState - we get it if no state is set.
			if ( !_currentState )
				setCurrentState( defaultState );
			return _currentState;
		}

		public function getPreviousState() : IScreenState
		{
			return _previousState;
		}

		public function getState( name : String ) : IScreenState
		{
			return states[ name ] as IScreenState;
		}

		public function getStateName( state : IScreenState ) : String
		{
			for ( var name : String in states )
				if ( states[ name ] == state )
					return name;
			return null;
		}

		public function removeState( state : IScreenState ) : IScreenState
		{
			var name : String = getStateName( state );
			return removeStateByName( name );
		}

		public function removeStateByName( name : String ) : IScreenState
		{
			if ( states[ name ])
			{
				var state : IScreenState = states[ name ];
				states[ name ] = null;
				delete states[ name ];

				return state;
			}
			return null;
		}

		public function setCurrentState( name : String, force : Boolean = false ) : Boolean
		{
			var newState : IScreenState = getState( name );

			if ( !newState )
				return false;

			var oldState : IScreenState = _currentState;

			/*if ( !force && oldState is AnimatedScreenState && ( AnimatedScreenState( oldState ).animating && !AnimatedScreenState( oldState ).canBeInturupted ) )
			{
				queStateName = name;
				AnimatedScreenState( oldState ).addEventListener( AnimationEvent.ANIMATION_FINISHED_EVENT, handleAnimationFinished );
				return false;
			}*/

			queStateName = null;

			_setNewState = true;
			_previousState = _currentState;
			_currentState = newState;

			// Old state gets notified it is changing out.
			if ( oldState )
				oldState.exit( this );
			// New state finds out it is coming in.    
			newState.completeDispatcher.addOnce( dispatchComplete );
			newState.enter( this );
			
			// Fire a transition event, if we have a dispatcher.

			return true;
		}
		
		private function dispatchComplete () : void
		{
			completeDispatcher.dispatch();
		}
	}
}
