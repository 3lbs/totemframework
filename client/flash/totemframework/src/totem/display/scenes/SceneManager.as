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

	import ladydebug.Logger;

	import totem.core.TotemSystem;
	import totem.display.layout.ScreenComposite;
	import totem.display.scenes.transition.GroupTransitionTask;

	public class SceneManager extends TotemSystem
	{
		private var _screenStateMachine : SceneStateMachine;

		private var transitionTask : GroupTransitionTask;

		public function SceneManager( screen : ScreenComposite, loadingScreen : BaseLoadingScreen )
		{
			_screenStateMachine = new SceneStateMachine( screen );
			transitionTask = new GroupTransitionTask( loadingScreen, screenStateMachine );
		}

		public function addState( name : String, state : ISceneState ) : void
		{
			_screenStateMachine.addState( name, state );
		}

		public function changeScreen( screenName : String, transition : String ) : void
		{
			if ( _screenStateMachine.getState( screenName ) != null && _screenStateMachine.currentStateName != screenName )
			{
				transitionTask.setCurrentState( screenName, transition )
			}
			else
			{
				Logger.warn( this, "changeScreen", "ScreenName Does not exsits: " + screenName );
			}
		}

		public function get screenStateMachine() : SceneStateMachine
		{
			return _screenStateMachine;
		}
	}
}
