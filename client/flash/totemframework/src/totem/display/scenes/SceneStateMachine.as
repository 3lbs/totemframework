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

package totem.display.scenes
{

	import flash.utils.Dictionary;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import totem.core.mvc.EventContextDispatcher;
	import totem.display.layout.ScreenComposite;

	public class SceneStateMachine extends EventContextDispatcher
	{

		public var parentScreen : ScreenComposite;

		public var states : Dictionary = new Dictionary();

		public var transitionDispatcher : ISignal = new Signal();

		private var _currentState : ISceneState = null;

		private var _previousState : ISceneState = null;

		public function SceneStateMachine( screen : ScreenComposite )
		{
			parentScreen = screen;
		}

		public function addState( name : String, state : ISceneState ) : void
		{
			states[ name ] = state;
		}

		public function get currentState() : ISceneState
		{
			return getCurrentState();
		}

		public function get currentStateName() : String
		{
			if ( _currentState )
				return _currentState.name;

			return "";
		}

		public function getCurrentState() : ISceneState
		{
			return _currentState;
		}

		public function getPreviousState() : ISceneState
		{
			return _previousState;
		}

		public function getState( name : String ) : ISceneState
		{
			return states[ name ] as ISceneState;
		}

		public function removeState( state : ISceneState ) : ISceneState
		{
			return removeStateByName( state.name );
		}

		public function removeStateByName( name : String ) : ISceneState
		{
			if ( states[ name ])
			{
				var state : ISceneState = states[ name ];
				states[ name ] = null;
				delete states[ name ];

				return state;
			}
			return null;
		}

		public function setCurrentState( name : String, force : Boolean = false ) : ISceneState
		{
			var newState : ISceneState = getState( name );

			if ( !newState )
				return null;

			_previousState = _currentState;
			_currentState = newState;

			// Old state gets notified it is changing out.
			if ( _previousState )
				_previousState.exit( this );

			_currentState.enter( this );

			return _currentState;
		}
	}
}
