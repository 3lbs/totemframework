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

	import totem.core.task.Task;
	import totem.display.scenes.SceneStateMachine;

	public class SwitchAndWaitForSceneTask extends Task
	{
		private var machine : SceneStateMachine;

		private var screenStateName : String;

		public function SwitchAndWaitForSceneTask( machine : SceneStateMachine, screen : String = "" )
		{
			super();

			this.machine = machine;
			screenStateName = screen;
		}

		override public function destroy() : void
		{
			machine = null;
			super.destroy();
		}

		public function setState( state : String ) : Boolean
		{
			if ( machine.currentStateName == state )
				return false;

			screenStateName = state;
			return true;
		}

		override protected function complete() : Boolean
		{
			return super.complete();

		}

		override protected function doStart() : void
		{
			machine.buildComplete.addOnce( complete );
			machine.setCurrentState( screenStateName );
		}
	}
}
