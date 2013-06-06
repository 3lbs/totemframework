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

	import totem.core.System;
	import totem.display.layout.ScreenComposite;

	public class SceneManager extends System
	{
		private var _screenStateMachine : SceneStateMachine;

		private var transitionTask : SceneTransitionTask;

		public function SceneManager( screen : ScreenComposite, loadingScreen : BaseLoadingScreen )
		{
			_screenStateMachine = new SceneStateMachine( screen );
			transitionTask = new SceneTransitionTask( loadingScreen, screenStateMachine );
		}

		public function addState( name : String, state : ISceneState ) : void
		{
			_screenStateMachine.addState( name, state );
		}

		public function changeScreen( screenName : String ) : void
		{
			if ( _screenStateMachine.getState( screenName ) != null && _screenStateMachine.currentStateName != screenName )
			{
				transitionTask.setCurrentState( screenName )
			}
		}

		public function get screenStateMachine() : SceneStateMachine
		{
			return _screenStateMachine;
		}
	}
}
