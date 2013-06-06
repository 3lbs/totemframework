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

	import totem.core.task.Task;

	public class SceneStateMachineTask extends Task
	{
		private var machine : SceneStateMachine;

		private var screenState : String;

		public function SceneStateMachineTask( machine : SceneStateMachine, screen : String = "" )
		{
			super();

			this.machine = machine;

			screenState = screen;
		}

		public function setState( state : String ) : Boolean
		{
			if ( machine.currentStateName == state )
				return false;

			screenState = state;
			return true;
		}

		override protected function doStart() : void
		{
			if ( machine.parentScreen.backgroundVisible )
			{
				machine.parentScreen.backgroundVisible = false;
			}

			machine.transitionDispatcher.addOnce( complete );
			machine.setCurrentState( screenState );
		}
	}
}
