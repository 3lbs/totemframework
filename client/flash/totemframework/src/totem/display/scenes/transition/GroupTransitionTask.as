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

package totem.display.scenes.transition
{

	import flash.display.BitmapData;
	
	import totem.core.task.SequenceTask;
	import totem.display.scenes.BaseLoadingScreen;
	import totem.display.scenes.SceneStateMachine;

	public class GroupTransitionTask extends SequenceTask
	{

		public static const FADE_TIME_IMAGE : Number = .5;

		public static const FADE_TIME_QUICK : Number = .4;

		public var isInLoadingScreen : Boolean;

		private var bitmapDataHolder : BitmapDataHolder = new BitmapDataHolder();

		private var fadeScreenInTask : FadeScreenInTask;

		private var fadeScreenOutTask : FadeScreenOutTask;

		private var loadingScreen : BaseLoadingScreen;

		private var nextSceneStateName : String;

		private var screenStateMachineTask : SwitchAndWaitForSceneTask;

		private var stateMachine : SceneStateMachine;

		private var transitionType : String;

		public function GroupTransitionTask( d : BaseLoadingScreen, machine : SceneStateMachine )
		{
			loadingScreen = d;
			stateMachine = machine;
		}

		public function setCurrentState( screen : String, transition : String ) : void
		{
			nextSceneStateName = screen;
			transitionType = transition;
			
			start();
		}
		
		override public function start() : Boolean
		{
			removeAllTasks();

			if ( stateMachine.currentState )
				stateMachine.currentState.prepareToExit();


			stateMachine.parentScreen.addScreen( loadingScreen );

			addTask( new FadeScreenInTask( loadingScreen, bitmapDataHolder, transitionType ));
			addTask( new SwitchAndWaitForSceneTask( stateMachine, nextSceneStateName ));
			addTask( new FadeScreenOutTask( loadingScreen, bitmapDataHolder, transitionType ));

			return super.start();
		}

		override protected function complete() : Boolean
		{
			bitmapDataHolder.dispose();
 
			loadingScreen.removeChildren();
			stateMachine.parentScreen.removeScreen( loadingScreen );
			return super.complete();
		}
	}
}
