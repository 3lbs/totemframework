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

	import totem.core.Destroyable;
	import totem.display.layout.ScreenComposite;
	import totem.monitors.progress.IProgressMonitor;

	public class SceneState extends Destroyable implements ISceneState
	{
		
		public static const NO_TRANSITION : String = "NoTransition";
		
		public static const TRANSITION_IMAGE : String = "UseImageForTransition";
		
		public static const TRANSITION_QUICK : String = "QuickTransitionNoImage";

		public var canBeDestroyed : Boolean = true;

		public var exitTransistion : String;

		public var isInitialized : Boolean = false;

		public var playOnce : Boolean = true;

		public var screen : ScreenComposite;

		protected var _progressMonitor : IProgressMonitor;

		private var _name : String;

		public function SceneState( name : String )
		{
			_name = name;
		}

		override public function destroy() : void
		{
			super.destroy();
			screen = null;
		}

		public function enter( fsm : SceneStateMachine ) : void
		{
			if ( !isInitialized )
				initialized();
		}

		public function exit( fsm : SceneStateMachine ) : void
		{
			if ( canBeDestroyed && playOnce )
			{
				fsm.removeState( this );
					//destroy();
			}
		}

		public function initialized() : void
		{
			if ( isInitialized )
				return;
			doInitialized();
			isInitialized = true;
		}

		public function get name() : String
		{
			return _name;
		}

		public function prepareToExit() : void
		{

		}

		public function get progressMonitor() : IProgressMonitor
		{
			return _progressMonitor;
		}

		public function transitionComplete() : void
		{

		}

		protected function doInitialized() : void
		{
		}
	}
}
