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

package totem.display.scenes
{

	import flash.utils.Dictionary;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import totem.core.mvc.model.Model;
	import totem.display.layout.ScreenComposite;
	import totem.monitors.promise.wait;

	public class SceneStateMachine extends Model
	{

		public var buildComplete : ISignal = new Signal();

		public var parentScreen : ScreenComposite;

		public var states : Dictionary = new Dictionary();

		private var _currentState : SceneState = null;

		private var _previousState : SceneState = null;

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

		public function getCurrentState() : SceneState
		{
			return _currentState;
		}

		public function getPreviousState() : SceneState
		{
			return _previousState;
		}

		public function getState( name : String ) : SceneState
		{
			return states[ name ];
		}

		public function removeState( state : SceneState ) : SceneState
		{
			return removeStateByName( state.name );
		}

		public function removeStateByName( name : String ) : SceneState
		{
			if ( states[ name ])
			{
				var state : SceneState = states[ name ];
				states[ name ] = null;
				delete states[ name ];

				return state;
			}
			return null;
		}

		public function setCurrentState( name : String, force : Boolean = false ) : ISceneState
		{
			var newState : SceneState = getState( name );

			if ( !newState )
				return null;

			_previousState = _currentState;
			_currentState = newState;

			// Old state gets notified it is changing out.
			if ( _previousState )
				_previousState.exit( this );

			wait( 100, enterNextState );

			return _currentState;
		}

		private function enterNextState() : void
		{
			_currentState.enter( this );
		}
	}
}
