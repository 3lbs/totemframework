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

	import dinozoo.view.screens.loadingscreen.BaseLoadingScreen;

	import flash.display.BitmapData;

	import totem.core.task.SequenceTask;

	public class SceneTransitionTask extends SequenceTask
	{

		public static const FADE_TIME_IMAGE : Number = .5;

		public static const FADE_TIME_QUICK : Number = .1;

		public var isInLoadingScreen : Boolean;

		private var animationBitmapData : BitmapData;

		private var fadeScreenInTask : FadeScreenInTask;

		private var fadeScreenOutTask : FadeScreenOutTask;

		private var loadingScreen : BaseLoadingScreen;

		private var nextSceneStateName : String;

		private var screenStateMachineTask : SceneStateMachineTask;

		private var stateMachine : SceneStateMachine;

		public function SceneTransitionTask( d : BaseLoadingScreen, machine : SceneStateMachine )
		{
			loadingScreen = d;

			stateMachine = machine;
		}

		public function setCurrentState( screen : String ) : void
		{
			nextSceneStateName = screen;
			start();
		}

		override public function start() : Boolean
		{
			removeAllTasks();

			// tel the current scene to pause for exit or get ready

			if ( stateMachine.currentState )
				stateMachine.currentState.prepareToExit();

			// find the next screen decide what kinda transition. also give to loading screen to test loading time
			var nextSceneState : ISceneState = stateMachine.getState( nextSceneStateName );

			var transition : String = SceneState.TRANSITION_QUICK;

			animationBitmapData = new BitmapData( loadingScreen.width, loadingScreen.height );

			// set the type of transition here on loadingscreen
			if ( nextSceneState.transitionType() == SceneState.TRANSITION_IMAGE || ( stateMachine.currentState && stateMachine.currentState.transitionType() == SceneState.TRANSITION_IMAGE ))
			{
				transition = SceneState.TRANSITION_IMAGE;
			}

			loadingScreen.addLoadingScene( nextSceneState );

			stateMachine.parentScreen.addScreen( loadingScreen );

			addTask( new FadeScreenInTask( loadingScreen, animationBitmapData, transition ));
			addTask( new SceneStateMachineTask( stateMachine, nextSceneStateName ));
			addTask( new FadeScreenOutTask( loadingScreen, animationBitmapData, transition ));

			return super.start();
		}

		override protected function complete() : Boolean
		{
			animationBitmapData.dispose();
			animationBitmapData = null;
			
			loadingScreen.finished();
			
			return super.complete();
		}
	}
}
